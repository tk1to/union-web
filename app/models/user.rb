class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: [:facebook]

  before_save   :downcase_email

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
  has_many :memberships, foreign_key: "member_id"

  has_many :blogs
  has_many :contacts, foreign_key: "send_user_id"

  has_many :entrying_circles, through: :entries, source: :circle
  has_many :entries

  has_many :favoriting_circles, through: :favorites, source: :circle
  has_many :favorites

  # 通知
  has_many :notifications, foreign_key: "hold_user_id"

  #フォロー関連
  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  #ユーザー足跡関連
  has_many :footed_prints, class_name:  "FootPrint",
                           foreign_key: "footed_user_id",
                           dependent: :destroy
  has_many :footed_users, through: :footed_prints, source: :footer_user

  #メッセージ関連
  has_many :creater_message_rooms, class_name: "MessageRoom",
                                  foreign_key: "creater_id"
  has_many :created_message_rooms, class_name: "MessageRoom",
                                  foreign_key: "created_id"

  #カテゴリー関連
  has_many :categories, through: :user_categories
  has_many :user_categories

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
    unless user
      user = User.create(
        uid: auth.uid,
        provider: auth.provider,
        name: auth.info.name,
        email: User.get_email(auth),
        password: Devise.friendly_token[4, 30])
    end
    user
  end

  # def free
  #   return false if !self.name
  #   return false if !self.college
  #   return false if !self.department
  #   return false if !self.sex
  #   return false if !self.birth_place
  #   return false if !self.home_place
  #   return false if !self.categories.any?
  #   true
  # end

  def basic_info
    info = ""
    info += self.college    + "/" if !self.college.blank?
    info += self.department + "/" if !self.department.blank?
    info += self.grade      + "/" if !self.grade.blank?
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
    cr_rooms = self.creater_message_rooms
    cd_rooms = self.created_message_rooms

    rooms = []
    cr_rooms.each do |room|
      rooms << room
    end
    cd_rooms.each do |room|
      rooms << room
    end
    rooms
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
end
