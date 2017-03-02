class AddStatusToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :status, :integer
  end
end
