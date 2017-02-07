class AddParamsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :title, :string
    add_column :events, :content, :text
    add_column :events, :circle_id, :integer
  end
end
