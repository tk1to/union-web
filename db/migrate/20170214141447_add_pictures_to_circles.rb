class AddPicturesToCircles < ActiveRecord::Migration
  def change
    add_column :circles, :picture, :string
    add_column :circles, :header_picture, :string
    add_column :blogs, :picture, :string
    add_column :events, :picture, :string
  end
end
