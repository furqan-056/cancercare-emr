class Appointment < ApplicationRecord
  belongs_to :organization
  belongs_to :slot

  belongs_to :patient, class_name: "User"
  belongs_to :doctor,  class_name: "User"
  belongs_to :manager, class_name: "User"

  enum :status, { pending: 0, approved: 1, rejected: 2, no_slots: 3 }

  before_validation :sync_from_slot, if: -> { slot.present? }
  before_validation :assign_manager_if_doctor
  after_create :mark_slot_unavailable

  after_create :send_notification_emails
  after_update :send_notification_emails, if: :saved_change_to_status?

  def self.ransackable_attributes(auth_object = nil)
    %w[date status doctor_id patient_id slot_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[doctor patient slot]
  end

  private

  def assign_manager_if_doctor
    if doctor.present? && doctor.role == "doctor" && manager_id.blank?
      self.manager_id = doctor.id
    end
  end

  def send_notification_emails
    if saved_change_to_status? && !previously_new_record?
      AppointmentMailer.status_changed_doctor(self).deliver_now
      AppointmentMailer.status_changed_patient(self).deliver_now
    end

    if previously_new_record?
      AppointmentMailer.notify_doctor(self).deliver_now
      AppointmentMailer.notify_patient(self).deliver_now
    end
  end

  def sync_from_slot
    self.doctor_id ||= slot.doctor_id
    self.date ||= slot.start_time
  end

  def mark_slot_unavailable
    slot.update!(available: false)
  end
end
