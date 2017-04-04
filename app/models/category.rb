class Category < ApplicationRecord
  has_many :circles, through: :circle_categories
  has_many :circle_categories
  validates :name, presence: true

  def Category.max
    3
  end
end
