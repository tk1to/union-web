class Blog < ActiveRecord::Base
  belongs_to :circle
  belongs_to :author, class_name: "User"

  mount_uploader :picture_1, PictureUploader
  mount_uploader :picture_2, PictureUploader
  mount_uploader :picture_3, PictureUploader
  validate  :picture_size

  private
    def picture_size
      if picture_1.size > 5.megabytes
        errors.add(:picture_1, "should be less than 5MB")
      end
      if picture_2.size > 5.megabytes
        errors.add(:picture_2, "should be less than 5MB")
      end
      if picture_3.size > 5.megabytes
        errors.add(:picture_3, "should be less than 5MB")
      end
    end
end
