class AddUserFirstLogin < ActiveRecord::Migration
  def change
    add_column :users, :first_facebook_login, :bool, default: true
  end
end
