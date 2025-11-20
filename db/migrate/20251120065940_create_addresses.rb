class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.string :street_address
      t.string :location
      t.string :city
      t.string :postal_code
      t.string :country
      t.references :addressable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
