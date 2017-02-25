class AddContentsToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :header_1, :string
    add_column :blogs, :header_2, :string
    add_column :blogs, :header_3, :string
    add_column :blogs, :content_1, :text
    add_column :blogs, :content_2, :text
    add_column :blogs, :content_3, :text
    add_column :blogs, :picture_1, :string
    add_column :blogs, :picture_2, :string
    add_column :blogs, :picture_3, :string
  end
end
