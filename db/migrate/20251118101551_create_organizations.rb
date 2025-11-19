class CreateOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :email
      t.string :organization_type
      t.string :phone_number
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
