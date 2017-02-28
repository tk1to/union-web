class AddChecked < ActiveRecord::Migration
  def change
    add_column :notifications, :checked, :bool, default: false
    add_column :messages, :checked, :bool, default: false
    add_column :foot_prints, :checked, :bool, default: false
  end
end
