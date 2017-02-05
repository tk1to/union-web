class AddIndexToMemberships < ActiveRecord::Migration
  def change
    add_index :memberships, :member_id
    add_index :memberships, :circle_id
    add_index :memberships, [:member_id, :circle_id], unique: true
  end
end
