class AddDefaultPointToCircles < ActiveRecord::Migration
  def change
    change_column :circles, :ranking_point, :integer, default: 0
  end
end
