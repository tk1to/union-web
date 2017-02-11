class AddIndexToCc < ActiveRecord::Migration
  def change
    add_index :circle_categories, [:circle_id, :category_id], unique: true
  end
end
