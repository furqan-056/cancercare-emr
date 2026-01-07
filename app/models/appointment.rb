class Appointment < ApplicationRecord
  belongs_to :organization
  belongs_to :slot, optional: true
  belongs_to :patient, class_name: "User"
  belongs_to :doctor,  class_name: "User"
  belongs_to :manager, class_name: "User", optional: true

  enum :status, { requested: 0, pending: 1, approved: 2, rejected: 3, no_slots: 4 }
  attr_accessor :requested_by_user

  before_validation :sync_from_slot, if: -> { slot.present? }
  after_create :mark_slot_unavailable, if: -> { slot.present? }
  after_commit :send_notification_emails, on: [:create, :update]

  def self.request_by_patient(patient:, doctor:)
    create(
      patient: patient,
      doctor: doctor,
      organization: patient.organization,
      status: :requested
    )
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[date status doctor_id patient_id slot_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[doctor patient slot]
  end

  private

  def send_notification_emails
    if previously_new_record?
      if status == "requested" && patient.present?
        AppointmentMailer.requested_by_patient_doctor(self).deliver_later(wait: 20.seconds)
        AppointmentMailer.requested_by_patient_confirmation(self).deliver_later(wait: 20.seconds)
      else
        AppointmentMailer.notify_doctor(self).deliver_later(wait: 20.seconds)
        AppointmentMailer.notify_patient(self).deliver_later(wait: 20.seconds)
      end
    end

    if saved_change_to_status? && !previously_new_record? && status != "requested"
      AppointmentMailer.status_changed_doctor(self).deliver_later(wait: 20.seconds)
      AppointmentMailer.status_changed_patient(self).deliver_later(wait: 20.seconds)
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
