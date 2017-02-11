class AddIndexToFavorites < ActiveRecord::Migration
  def change
    add_index :favorites, :circle_id
    add_index :favorites, :user_id
    add_index :favorites, [:circle_id, :user_id], unique: true
  end
end
