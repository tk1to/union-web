class RemoveFussyTagsFromCircles < ActiveRecord::Migration
  def change
    remove_column :circles, :fussy_tags, :string
  end
end
