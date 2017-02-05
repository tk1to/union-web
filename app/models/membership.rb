class Membership < ActiveRecord::Base
  belongs_to :member, class_name: "User"
  belongs_to :circle
  validates :member_id, presence: true
  validates :circle_id, presence: true
end
