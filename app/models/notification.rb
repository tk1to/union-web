class Notification < ActiveRecord::Base

  belongs_to :hold_user, class_name: "User"

  belongs_to :circle
  belongs_to :user

  validates :hold_user_id, presence: true
  enum type: {from_user: 0, from_circle: 1}
end
