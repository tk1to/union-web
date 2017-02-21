class CircleFootPrint < ActiveRecord::Base
  default_scope -> {order("updated_at DESC")}
  belongs_to :footed_user, class_name: "User"
  belongs_to :circle, class_name: "Circle"
  validates :footed_user_id, presence: true
  validates :circle_id, presence: true
end
