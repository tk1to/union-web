class AddTypeToCircles < ActiveRecord::Migration
  def change
    add_column :circles, :type, :string
  end
end
