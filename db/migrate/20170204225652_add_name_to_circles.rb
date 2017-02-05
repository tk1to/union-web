class AddNameToCircles < ActiveRecord::Migration
  def change
    add_column :circles, :name, :string
    add_column :circles, :description, :string
  end
end
