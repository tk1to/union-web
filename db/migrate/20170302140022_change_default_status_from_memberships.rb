class ChangeDefaultStatusFromMemberships < ActiveRecord::Migration
  def change
    change_column :memberships, :status, :integer, default: 3
  end
end
