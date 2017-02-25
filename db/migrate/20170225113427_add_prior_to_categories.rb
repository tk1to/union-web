class AddPriorToCategories < ActiveRecord::Migration
  def change
    add_column :circle_categories, :priority, :integer
    add_column :user_categories, :priority, :integer
  end
end
