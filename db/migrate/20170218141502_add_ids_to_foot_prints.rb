class AddIdsToFootPrints < ActiveRecord::Migration
  def change
    add_column :foot_prints, :footed_id, :integer
    add_column :foot_prints, :footer_id, :integer
  end
end
