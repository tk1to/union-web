class Membership < ActiveRecord::Base
  belong_to :member, class_name: "User"
  belong_to :circle
  validates :member_id, presence: true
  validates :circle_id, presence: true
end
