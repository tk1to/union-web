class ChangeColumnCircles5 < ActiveRecord::Migration
  def change
    Circle.update_all(people_scale: nil)
    Circle.update_all(annual_fee: nil)
    change_column :circles, :people_scale, "integer USING CAST(people_scale AS integer)"
    change_column :circles, :annual_fee, "integer USING CAST(annual_fee AS integer)"
  end
end
