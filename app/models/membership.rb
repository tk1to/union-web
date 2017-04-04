class Membership < ApplicationRecord
  belongs_to :member, class_name: "User"
  belongs_to :circle
  validates :member_id, presence: true
  validates :circle_id, presence: true

  enum status: {chief: 0, admin: 1, editor: 2, ordinary: 3}
end
