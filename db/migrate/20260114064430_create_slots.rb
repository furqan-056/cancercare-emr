class CreateSlots < ActiveRecord::Migration[8.0]
  def change
    create_table :slots do |t|
      t.references :doctor, null: false, foreign_key: { to_table: :users }
      t.integer :weekday, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.boolean :is_recurring, default: true

      t.timestamps
    end
  end
end
