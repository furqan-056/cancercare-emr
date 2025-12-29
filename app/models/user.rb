class User < ApplicationRecord
  belongs_to :organization, optional: true
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  has_many :patient_appointments, class_name: "Appointment", foreign_key: :patient_id, dependent: :destroy
  has_many :doctor_appointments, class_name: "Appointment", foreign_key: :doctor_id
  has_many :managed_appointments, class_name: "Appointment", foreign_key: :manager_id

  enum :role, { manager: 0, doctor: 1, patient: 2 }

  validates :role, :organization, presence: true
  before_validation :set_temp_password_for_new_user, on: :create
  before_validation :sync_type_with_role, on: [:create, :update]

  after_commit :send_reset_email, on: :create

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
    %w[email role first_name last_name email phone]
  end

  def self.ransackable_associations(auth_object = nil)
    ["organization"]
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def sync_type_with_role
    return if role.blank?

    self.type =
      case role.to_s
      when "doctor"  then "Doctor"
      when "manager" then "Manager"
      when "patient" then "Patient"
      else type
      end
  end

  def set_temp_password_for_new_user
    return if password.present? && password_confirmation.present?

    generated_password = SecureRandom.hex(10)
    self.password = generated_password
    self.password_confirmation = generated_password
  end

  def send_reset_email
    send_reset_password_instructions
  end
end
