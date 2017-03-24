class AddColumnToCirclesWelcomeEvent < ActiveRecord::Migration
  def change
    add_column :circles, :welcome_event_schedule, :string
  end
end
