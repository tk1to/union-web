class AddInformationsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :schedule, :string
    add_column :events, :fee, :integer
    add_column :events, :capacity, :integer
    add_column :events, :place, :string
  end
end
