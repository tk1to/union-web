class CreateFootPrints < ActiveRecord::Migration
  def change
    create_table :foot_prints do |t|

      t.timestamps null: false
    end
  end
end
