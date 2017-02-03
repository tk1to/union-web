class AddIntroduceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :introduce, :string
    add_column :users, :action, :string
    add_column :users, :hobby, :string
  end
end
