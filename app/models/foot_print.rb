class FootPrint < ActiveRecord::Base
  belongs_to :footer_user, class_name: "User"
  belongs_to :footed_user, class_name: "User"
  validates :footer_user_id, presence: true
  validates :footed_user_id, presence: true
end
