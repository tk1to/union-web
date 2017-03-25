class Yappariiranai < ActiveRecord::Migration
  def change
    remove_column :users, :facebook_image, :string
  end
end
