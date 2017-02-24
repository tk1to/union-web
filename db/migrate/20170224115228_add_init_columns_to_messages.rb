class AddInitColumnsToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :sender_id, :integer
    add_column :messages, :receiver_id, :integer
    add_column :messages, :content, :string
    add_column :messages, :be_newest, :bool
  end
end
