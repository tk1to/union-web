class RemoveDateFromCiercles < ActiveRecord::Migration
  def change
    remove_column :circles, :welcome_event_schedule, :date
  end
end
