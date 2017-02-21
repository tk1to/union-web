class CircleFootPrint < ActiveRecord::Base
  default_scope -> {order("updated_at DESC")}
  belongs_to :footer_user, class_name: "User"
  belongs_to :footed_circle, class_name: "Circle"
  validates :footer_user_id, presence: true
  validates :footed_circle_id, presence: true
end
