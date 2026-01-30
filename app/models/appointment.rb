class Appointment < ApplicationRecord
  belongs_to :slot
  belongs_to :doctor, class_name: "User"
  belongs_to :patient, class_name: "User"

  validates :appointment_date, presence: true
  validates :slot_id, :reason, presence: true
  validates :slot_id, uniqueness: { scope: :appointment_date, message: "is already booked for this date" }, if: :slot_present?

  enum :status, { pending: 0, approved: 1, rejected: 2 }

  after_create_commit :send_created_email
  before_destroy :prevent_patient_from_deleting_today

  scope :recent_order_first, -> { order(appointment_date: :desc) }
  attr_accessor :current_user_for_destroy

  def self.ransackable_attributes(auth_object = nil)
    ["appointment_date", "doctor_id", "patient_id", "reason", "slot_id", "status"]
  end

  def send_created_email
    AppointmentMailer.created(self).deliver_later(wait: 5.seconds)
  end

  private

  def slot_present?
    slot_id.present? && appointment_date.present?
  end

  def prevent_patient_from_deleting_today
    if current_user_for_destroy&.patient? && appointment_date == Date.current
      errors.add(:base, "You cannot delete an appointment scheduled for today")
      throw(:abort)
    end
  end
end
