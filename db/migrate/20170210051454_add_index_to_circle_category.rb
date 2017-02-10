class AddIndexToCircleCategory < ActiveRecord::Migration
  def change
    add_index :circle_categories, :circle_id
    add_index :circle_categories, :category_id
    add_index :circle_categories, [:circle_id, :category_id], unique: true
  end
end
