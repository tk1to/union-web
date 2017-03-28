class AddRankingPointToCirlces < ActiveRecord::Migration
  def change
    add_column :circles, :ranking_point, :integer
  end
end
