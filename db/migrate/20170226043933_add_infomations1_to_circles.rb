class AddInfomations1ToCircles < ActiveRecord::Migration
  def change
    add_column :circles, :activity, :text
    add_column :circles, :join_colleges, :string
    add_column :circles, :people_scale, :string
    add_column :circles, :activity_place, :string
    add_column :circles, :activity_frequency, :string
    add_column :circles, :annual_fee, :string
    add_column :circles, :party_frequency, :string
  end
end
