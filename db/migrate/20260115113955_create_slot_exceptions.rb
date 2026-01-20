class CreateSlotExceptions < ActiveRecord::Migration[8.0]
  def change
    create_table :slot_exceptions do |t|
      t.references :slot, foreign_key: true, null: true
      t.references :doctor, foreign_key: { to_table: :users }, null: true
      t.date :exception_date, null: false
      t.integer :exception_type, default: 0
      t.string :reason
      t.timestamps
    end

    add_index :slot_exceptions, [:slot_id, :exception_date], unique: true
  end
end
