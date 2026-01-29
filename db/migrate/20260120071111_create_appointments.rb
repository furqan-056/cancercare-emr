class CreateAppointments < ActiveRecord::Migration[8.0]
  def change
    create_table :appointments do |t|
      t.references :slot, null: false, foreign_key: true
      t.references :doctor, null: false, foreign_key: { to_table: :users }
      t.references :patient, null: false, foreign_key: { to_table: :users }

      t.date :appointment_date, null: false
      t.integer :status, null: false, default: 0
      t.string :reason

      t.timestamps
    end

    add_index :appointments, [:slot_id, :appointment_date], unique: true

    add_index :appointments, [:doctor_id, :appointment_date]
    add_index :appointments, [:patient_id, :appointment_date]
  end
end
