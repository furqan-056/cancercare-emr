class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  validates :street_address, :location, :city, :postal_code, :country, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[id addressable_id addressable_type street_address location city postal_code country created_at updated_at]
  end
end
