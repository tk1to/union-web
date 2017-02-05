class AddCircleIdToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :circle_id, :integer
  end
end
