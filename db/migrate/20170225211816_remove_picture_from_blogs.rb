class RemovePictureFromBlogs < ActiveRecord::Migration
  def change
    remove_column :blogs, :picture, :string
  end
end
