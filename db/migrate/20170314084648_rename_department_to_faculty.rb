class RenameDepartmentToFaculty < ActiveRecord::Migration
  def change
    rename_column :users, :department, :faculty
  end
end
