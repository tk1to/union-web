class AddInfomationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :birth_place, :string
    add_column :users, :home_place, :string
    add_column :users, :my_like_atom, :string
    add_column :users, :career, :string
    add_column :users, :future, :string
  end
end
