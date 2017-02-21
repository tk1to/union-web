class CreateCircleFootPrints < ActiveRecord::Migration
  def change
    create_table :circle_foot_prints do |t|

      t.timestamps null: false
    end
  end
end
