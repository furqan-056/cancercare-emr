class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  validates :street_address, :location, :city, :postal_code, :country, presence: true
end
