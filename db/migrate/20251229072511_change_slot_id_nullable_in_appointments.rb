class ChangeSlotIdNullableInAppointments < ActiveRecord::Migration[8.0]
  def change
    change_column_null :appointments, :slot_id, true
  end
end
