class AddHeaderPictureToUsers < ActiveRecord::Migration
  def change
    add_column :users, :header_picture, :string
  end
end
