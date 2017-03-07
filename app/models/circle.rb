class Circle < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true
  validates :picture, presence: true
  validates :header_picture, presence: true

  has_many :members, through: :memberships, class_name: "User"
  has_many :memberships, dependent: :destroy
  has_many :blogs
  has_many :events
  has_many :contacts, foreign_key: "receive_circle_id"

  # カテゴリー関連
  has_many :categories, through: :circle_categories
  has_many :circle_categories, dependent: :destroy

  # メンバー申請関連
  has_many :entrying_users, through: :entries, source: :user
  has_many :entries

  # 気になる関連
  has_many :favorited_users, through: :favorites, source: :user
  has_many :favorites, dependent: :destroy

  # 画像関連
  mount_uploader :picture, PictureUploader
  validate  :picture_size
  mount_uploader :header_picture, PictureUploader
  validate  :header_picture_size

  scope :ascend, -> { order(:id) }

  private
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
