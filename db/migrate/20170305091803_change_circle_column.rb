class ChangeCircleColumn < ActiveRecord::Migration
  def change
    add_column :circles, :fussy_tags, :string
    remove_column :circles, :activity
  end
end
