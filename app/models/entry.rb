class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :circle
  validates :user_id, presence: true
  validates :circle_id, presence: true
end
