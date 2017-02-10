class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :circle_id
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :entries, :circle_id
    add_index :entries, :user_id
    add_index :entries, [:circle_id, :user_id], unique: true
  end
end
