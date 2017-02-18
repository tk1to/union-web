class RenameColumnFromFootPrints < ActiveRecord::Migration
  def change
    rename_column :foot_prints, :footer_id, :footer_user_id
    rename_column :foot_prints, :footed_id, :footed_user_id
  end
end
