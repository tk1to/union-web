class Circle < ActiveRecord::Base
  validates :name, presence: true

  has_many :members, through: :memberships, class_name: "User"
  has_many :memberships
  has_many :blogs
  has_many :events
  has_many :contacts, foreign_key: "receive_circle_id"

  has_many :categories, through: :circle_categories
  has_many :circle_categories

  has_many :entrying_users, through: :entries, source: :user
  has_many :entries
end
