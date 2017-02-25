class Blog < ActiveRecord::Base
  belongs_to :circle
  belongs_to :author, class_name: "User"

  mount_uploader :picture_1, PictureUploader
  mount_uploader :picture_2, PictureUploader
  mount_uploader :picture_3, PictureUploader
  validate  :picture_size

  def picture(i)
    return_picture = nil
    if i == 1
      return_picture = self.picture_1
    elsif i == 2
      return_picture = self.picture_2
    elsif i == 3
      return_picture = self.picture_3
    end
  end

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
