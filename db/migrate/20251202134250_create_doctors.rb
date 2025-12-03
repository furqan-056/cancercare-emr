class CreateDoctors < ActiveRecord::Migration[8.0]
  def change
    create_table :doctors do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :specialization
      t.string :department
      t.integer :years_of_experience
      t.decimal :consultation_fee, precision: 8, scale: 2
      t.string :availability
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
