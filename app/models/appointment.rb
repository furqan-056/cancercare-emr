class Appointment < ApplicationRecord
  belongs_to :slot
  belongs_to :doctor, class_name: "User"
  belongs_to :patient, class_name: "User"

  validates :appointment_date, presence: true
  validates :slot_id, :reason, presence: true
  validates :slot_id, uniqueness: { scope: :appointment_date, message: "is already booked for this date" }, if: :slot_present?

  enum :status, { pending: 0, approved: 1, rejected: 2 }

  after_create_commit :send_created_email

  scope :recent_order_first, -> { order(appointment_date: :desc) }

  def self.ransackable_attributes(auth_object = nil)
    ["appointment_date", "doctor_id", "patient_id", "reason", "slot_id", "status"]
  end

  def send_created_email
    AppointmentMailer.created(self).deliver_later
  end

  private

  def slot_present?
    slot_id.present? && appointment_date.present?
  end
end
