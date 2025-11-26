class User < ApplicationRecord
  belongs_to :organization, optional: true
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  enum :role, { manager: 0, doctor: 1, patient: 2 }

  validates :role, presence: true
  validates :organization, presence: true
end
