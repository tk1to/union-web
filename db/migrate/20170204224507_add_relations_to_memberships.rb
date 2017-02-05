class AddRelationsToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :member_id, :integer
    add_column :memberships, :circle_id, :integer
  end
end
