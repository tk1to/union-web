class AddColumnToWes < ActiveRecord::Migration
  def change
    add_column :welcome_event_schedules, :schedule, :date
    add_column :welcome_event_schedules, :circle_id, :integer
  end
end
