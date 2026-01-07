class CreateSlots < ActiveRecord::Migration[8.0]
  def change
    create_table :slots do |t|
      t.references :doctor, null: false, foreign_key: { to_table: :users }
      t.references :organization, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :available, default: true

      t.timestamps
    end
  end
end
