class AddIdsToCircleFootPrints < ActiveRecord::Migration
  def change
    add_column :circle_foot_prints, :footed_circle_id, :integer
    add_column :circle_foot_prints, :footer_user_id, :integer
  end
end
