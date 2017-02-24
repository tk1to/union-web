class ChangeColumnFromUsers < ActiveRecord::Migration
  def change
    change_column :users, :grade, :string
  end
end
