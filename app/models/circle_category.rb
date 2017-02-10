class CircleCategory < ActiveRecord::Base
  belongs_to :circle
  belongs_to :category
  validates :circle_id, presence: true
  validates :category_id, presence: true
end
