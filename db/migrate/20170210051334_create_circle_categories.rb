class CreateCircleCategories < ActiveRecord::Migration
  def change
    create_table :circle_categories do |t|
      t.integer :circle_id
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
