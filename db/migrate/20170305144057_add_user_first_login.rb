class AddUserFirstLogin < ActiveRecord::Migration
  def change
    add_column :users, :first_facebook_login, :bool, defualt: true
  end
end
