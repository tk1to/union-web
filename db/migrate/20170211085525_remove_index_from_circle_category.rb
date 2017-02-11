class RemoveIndexFromCircleCategory < ActiveRecord::Migration
  def change
    remove_index :circle_categories, [:circle_id, :category_id]
  end
end
