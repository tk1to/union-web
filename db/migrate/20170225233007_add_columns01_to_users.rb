class AddColumns01ToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sex, :integer
    add_column :users, :oppotunity, :text
    rename_column :users, :my_like_atom, :my_circle_atom
  end
end
