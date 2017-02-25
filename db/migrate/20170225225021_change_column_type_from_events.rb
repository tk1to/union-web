class ChangeColumnTypeFromEvents < ActiveRecord::Migration
  def change
    change_column :events, :fee, :string
    change_column :events, :capacity, :string
  end
end
