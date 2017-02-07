class AddParamsToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :content, :text
    add_column :contacts, :send_user_id, :integer
    add_column :contacts, :receive_circle_id, :integer
  end
end
