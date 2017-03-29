class AddDetailToschedule < ActiveRecord::Migration
  def change
    add_column :welcome_event_schedules, :detail, :string
  end
end
