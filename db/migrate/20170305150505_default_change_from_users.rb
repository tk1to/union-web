class DefaultChangeFromUsers < ActiveRecord::Migration
  def change
    change_column :users, :first_facebook_login, :bool, default: true
  end
end
