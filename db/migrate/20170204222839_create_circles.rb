class CreateCircles < ActiveRecord::Migration
  def change
    create_table :circles do |t|

      t.timestamps null: false
    end
  end
end
