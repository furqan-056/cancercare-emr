class AddDoctorFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone, :string
    add_column :users, :specialization, :string
    add_column :users, :department, :string
    add_column :users, :years_of_experience, :integer
    add_column :users, :availability, :string
  end
end
