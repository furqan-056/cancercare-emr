class Appointment < ApplicationRecord
  belongs_to :slot
  belongs_to :doctor, class_name: "User"
  belongs_to :patient, class_name: "User"

  validates :appointment_date, presence: true
  validates :slot_id, :reason, presence: true

  enum :status, { pending: 0, approved: 1, rejected: 2 }

  validate :slot_must_be_available, on: :create
  before_validation :set_default_status, on: :create
  after_create_commit :send_created_email

  scope :recent_order_first, -> { order(appointment_date: :desc) }

  def self.ransackable_attributes(auth_object = nil)
    ["appointment_date", "doctor_id", "patient_id", "reason", "slot_id", "status"]
  end

  def set_default_status
    self.status ||= :pending
  end

  def destroy_by(user)
    if user.role == "patient" && appointment_date == Date.current
      errors.add(:base, "You cannot delete an appointment scheduled for today")
      return false
    end

    destroy
  end

  def send_created_email
    AppointmentMailer.created(self).deliver_now
  end

  def send_status_email
    AppointmentMailer.status_changed(self).deliver_now
  end

  def send_updated_by_patient_email
      AppointmentMailer.updated_by_patient(self).deliver_now
  end

  private

  def slot_must_be_available
    return unless slot && appointment_date

    if SlotException.where(exception_date: appointment_date).where("slot_id IS NULL OR slot_id = ?", slot.id).exists?
      errors.add(:appointment_date, "slot is blocked on this date")
    elsif slot.appointments.exists?(appointment_date: appointment_date)
      errors.add(:slot_id, "slot already booked")
    end
  end
end
