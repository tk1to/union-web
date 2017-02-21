class RenameFootFromCircleFootPrints < ActiveRecord::Migration
  def change
    rename_column :circle_foot_prints, :footed_circle_id, :circle_id
    rename_column :circle_foot_prints, :footer_user_id, :footed_user_id
  end
end
