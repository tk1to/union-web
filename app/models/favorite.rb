class Favorite < ApplicationRecord
  belongs_to :circle
  belongs_to :user
  validates :circle_id, presence: true
  validates :user_id, presence: true
end
