class Circle < ActiveRecord::Base
  validates :name, presence: true

  has_many :members, through: :memberships, class_name: "User"
  has_many :memberships
  has_many :blogs
  has_many :events
  has_many :contacts
end
