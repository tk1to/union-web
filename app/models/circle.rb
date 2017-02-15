class Circle < ActiveRecord::Base
  validates :name, presence: true

  has_many :members, through: :memberships, class_name: "User"
  has_many :memberships
  has_many :blogs
  has_many :events
  has_many :contacts, foreign_key: "receive_circle_id"

  has_many :categories, through: :circle_categories
  has_many :circle_categories

  has_many :entrying_users, through: :entries, source: :user
  has_many :entries

  has_many :favorited_users, through: :favorites, source: :user
  has_many :favorites

  mount_uploader :picture, PictureUploader
  validate  :picture_size
  mount_uploader :header_picture, PictureUploader
  validate  :header_picture_size

  scope :ascend, -> { order(:id) }
  default_scope { order(:id) }

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
