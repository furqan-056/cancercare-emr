class RemoveConsultationFeeFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :consultation_fee, :decimal
  end
end
