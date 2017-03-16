class ModifyColumnUsers < ActiveRecord::Migration
  def change
    add_column :users, :new_foots_count, :integer
    remove_column :users, :new_foots_exist, :bool
  end
end
