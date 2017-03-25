class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: [:facebook]

  before_save :downcase_email

  validates :name, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence:   true, length: { maximum: 255 },
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :introduce, length: { maximum: 500 }
  validates :want_to_do, length: { maximum: 500 }
  validates :hobby, length: { maximum: 500 }

  # 画像関連
  mount_uploader :picture, PictureUploader
  validate  :picture_size
  mount_uploader :header_picture, PictureUploader
  validate  :header_picture_size

  has_many :circles, through: :memberships
  has_many :memberships, foreign_key: "member_id", dependent: :destroy

  has_many :blogs
  has_many :contacts, foreign_key: "send_user_id"

  has_many :entrying_circles, through: :entries, source: :circle
  has_many :entries, dependent: :destroy

  has_many :favoriting_circles, through: :favorites, source: :circle
  has_many :favorites, dependent: :destroy

  # 通知
  has_many :notifications, foreign_key: "hold_user_id", dependent: :destroy

  #フォロー関連
  has_many :active_relationships,  ->{order("id DESC") },
                                   class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, ->{order("id DESC") },
                                   class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  #ユーザー足跡関連
  has_many :footed_prints, class_name:  "FootPrint",
                           foreign_key: "footed_user_id",
                           dependent: :destroy
  has_many :footed_users, through: :footed_prints, source: :footer_user

  #メッセージ関連
  has_many :creater_message_rooms, class_name: "MessageRoom",
                                  foreign_key: "creater_id",
                                  dependent: :destroy
  has_many :created_message_rooms, class_name: "MessageRoom",
                                  foreign_key: "created_id",
                                  dependent: :destroy

  #カテゴリー関連
  has_many :categories, through: :user_categories
  has_many :user_categories, dependent: :destroy

  # ユーザーをフォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end
  # ユーザーをアンフォローする
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end
  def mutual_follow?(user)
    self.following?(user) && user.following?(self)
  end

  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first
    if !user
      user = User.create(
        uid:       auth.uid,
        provider:  auth.provider,
        name:      auth.info.name,
        email:     User.get_email(auth),
        password:  Devise.friendly_token[6, 24],
        first_facebook_login: false,
      )
      user.skip_confirmation!
      user.save
    elsif user.first_facebook_login
      user.update_attribute(:first_facebook_login, false)
      user.update_attribute(:name, auth.info.name)
      user.update_attribute(:email, User.get_email(auth))
      user.update_attribute(:password, Devise.friendly_token[6, 24])
      user.skip_confirmation!
      user.save
    end
    user
  end

  def free
    properties = []
    properties << "名前"                if self.name.blank?
    properties << "大学"                if self.college.blank?
    properties << "学部"                if self.faculty.blank?
    properties << "性別"                if self.sex.blank?
    properties << "住まい"              if self.birth_place.blank?
    properties << "出身地"              if self.home_place.blank?
    properties << "興味のあるカテゴリー"  if !self.categories.any?
    [properties.blank?, properties]
  end

  def basic_info
    info = ""
    info += self.college    + "/" if !self.college.blank?
    info += self.faculty    + "/" if !self.faculty.blank?
    info += self.grade+"年" + "/" if !self.grade.blank?
    info += self.sex_label  + "/" if !self.sex.blank?
    info[0..-2]
  end

  def sex_label
    label = nil
    if self.sex == 0
      label = "男性"
    elsif self.sex == 1
      label = "女性"
    end
  end

  def message_rooms
    creater = MessageRoom.arel_table[:creater_id]
    created = MessageRoom.arel_table[:created_id]
    MessageRoom.where(creater.eq(self.id).or(created.eq(self.id))).order(last_updated_time: :DESC)
  end

  def display_categories
    response = ""
    self.categories.each do |c|
      response += "/" if !response.blank?
      response += c.name
    end
    response
  end

  private

    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
    def header_picture_size
      if header_picture.size > 5.megabytes
        errors.add(:header_picture, "should be less than 5MB")
      end
    end

    def self.get_email(auth)
      email = auth.info.email
      email = "#{auth.provider}-#{auth.uid}@example.com" if email.blank?
      email
    end
    # def self.dummy_email(auth)
    #   "#{auth.uid}-#{auth.provider}@example.com"
    # end
end
