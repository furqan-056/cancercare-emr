class User < ApplicationRecord
  belongs_to :organization, optional: true
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  enum :role, { manager: 0, doctor: 1, patient: 2 }

  validates :role, presence: true
  validates :organization, presence: true
  before_validation :set_temp_password_for_new_user, on: :create

  ransacker :role do |parent|
    Arel.sql("CASE users.role
      WHEN 0 THEN 'manager'
      WHEN 1 THEN 'doctor'
      WHEN 2 THEN 'patient'
    END")
  end

  ransacker :organization_name do |parent|
    Arel.sql("(SELECT name FROM organizations WHERE organizations.id = users.organization_id)")
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id email role organization_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    ["organization"]
  end

  private

  def set_temp_password_for_new_user
    return if password.present? && password_confirmation.present?

    generated_password = SecureRandom.hex(10)
    self.password = generated_password
    self.password_confirmation = generated_password
  end
end
