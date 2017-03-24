class ChangeColumnDateFromCircles < ActiveRecord::Migration
  def change
    Circle.update_all(welcome_event_schedule: nil)
    change_column :circles, :welcome_event_schedule, "date USING CAST(welcome_event_schedule AS date)"
  end
end
