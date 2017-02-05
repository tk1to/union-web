class AddAuthorIdToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :author_id, :integer
  end
end
