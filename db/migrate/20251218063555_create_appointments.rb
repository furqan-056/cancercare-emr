class CreateAppointments < ActiveRecord::Migration[8.0]
  def change
    create_table :appointments do |t|
      t.references :patient, null: false, foreign_key: { to_table: :users }
      t.references :doctor, null: false, foreign_key: { to_table: :users }
      t.references :manager, null: false, foreign_key: { to_table: :users }
      t.references :organization, null: false, foreign_key: true
      t.references :slot, null: false, foreign_key: true
      t.datetime :date
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
