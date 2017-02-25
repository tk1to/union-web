class RemoveContentFromBlogs < ActiveRecord::Migration
  def change
    remove_column :blogs, :content, :text
  end
end
