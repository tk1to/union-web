class RenameTypeFromCircle < ActiveRecord::Migration
  def change
    rename_column :circles, :type, :org_type
  end
end
