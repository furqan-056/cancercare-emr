class Appointment < ApplicationRecord
  belongs_to :organization
  belongs_to :slot

  belongs_to :patient, class_name: "User"
  belongs_to :doctor,  class_name: "User"
  belongs_to :manager, class_name: "User"

  enum :status, { pending: 0, approved: 1, rejected: 2, no_slots: 3 }

  before_validation :sync_from_slot
  after_create :mark_slot_unavailable

  private

  def sync_from_slot
    self.doctor_id ||= slot.doctor_id
    self.date ||= slot.start_time
  end

  def mark_slot_unavailable
    slot.update!(available: false)
  end
end
