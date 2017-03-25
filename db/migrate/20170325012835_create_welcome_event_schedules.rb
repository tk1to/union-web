class CreateWelcomeEventSchedules < ActiveRecord::Migration
  def change
    create_table :welcome_event_schedules do |t|

      t.timestamps null: false
    end
  end
end
