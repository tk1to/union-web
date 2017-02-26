class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: [:facebook]

  # attr_accessor :remember_token, :activation_token
  before_save   :downcase_email
  # before_create :create_activation_digest

  validates :name, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence:   true, length: { maximum: 255 },
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  # has_secure_password
  # validates :password, presence: true, length: { minimum: 4 }, allow_nil: true

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

  # 与えられた文字列のハッシュ値を返す
  # def User.digest(string)
  #   cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
  #                                                 BCrypt::Engine.cost
  #   BCrypt::Password.create(string, cost: cost)
  # end

  # ランダムなトークンを返す
  # def User.new_token
  #   SecureRandom.urlsafe_base64
  # end
  # 永続的セッションで使用するユーザーをデータベースに記憶する
  # def remember
  #   self.remember_token = User.new_token
  #   update_attribute(:remember_digest, User.digest(remember_token))
  # end
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  # def authenticated?(attribute, token)
  #   digest = send("#{attribute}_digest")
  #   return false if digest.nil?
  #   BCrypt::Password.new(digest).is_password?(token)
  # end

  # ユーザーログインを破棄する
  # def forget
  #   update_attribute(:remember_digest, nil)
  # end

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

  # アカウントを有効にする
  # def activate
  #   update_attribute(:activated,    true)
  #   update_attribute(:activated_at, Time.zone.now)
  # end
  # 有効化用のメールを送信する
  # def send_activation_email
  #   UserMailer.account_activation(self).deliver_now
  # end

  def self.find_for_facebook_oauth(auth)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    unless user
      user = User.create( name:     auth.extra.raw_info.name,
                          provider: auth.provider,
                          uid:      auth.uid,
                          email:    auth.info.email,
                          token:    auth.credentials.token,
                          password: Devise.friendly_token[0,20] )
    end
    user
  end

  def free
    return false if !self.name
    return false if !self.college
    return false if !self.department
    return false if !self.sex
    return false if !self.birth_place
    return false if !self.home_place
    return false if !self.categories.any?
    true
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
end
