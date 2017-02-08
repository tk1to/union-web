class DropRelationTable < ActiveRecord::Migration
  def change
    drop_table :user_relationships
  end
end
