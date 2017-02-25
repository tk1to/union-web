class RemoveNewestFromMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :be_newest, :bool
  end
end
