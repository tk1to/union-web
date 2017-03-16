class AddSessionToUser < ActiveRecord::Migration
  def change
    remove_column :users, :new_foots_count, :bool
    add_column :users, :tutorialed, :bool, default: false
  end
end
