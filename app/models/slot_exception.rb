class SlotException < ApplicationRecord
  has_paper_trail
  belongs_to :slot, optional: true
  belongs_to :doctor, class_name: "User", optional: true

  enum :exception_type, { holiday: 0, doctor_unavailable: 1, blocked_date: 2 }

  validates :reason, presence: true
  validates :exception_date, uniqueness: { scope: :slot_id, message: "already has an exception for this specific slot" }, if: -> { slot_id.present? }
  before_create :assign_doctor_unavailable_type

  scope :for_date, ->(date) { where(exception_date: date) }
  scope :for_doctor, ->(doctor_id) { where(doctor_id: doctor_id) }
  scope :holidays, -> { where(exception_type: :holiday) }
  scope :recent_first, -> { order(exception_date: :desc) }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "doctor_id", "exception_date", "exception_type", "id", "reason", "slot_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["doctor", "slot"]
  end

  def self.blocked?(slot_id:, doctor_id:, date:)
    where(exception_date: date).where("slot_id = ? OR slot_id IS NULL", slot_id).where("doctor_id IS NULL OR doctor_id = ?", doctor_id).exists?
  end

  def self.exceptions_for_calendar(doctor)
    {
      holidays: holidays.pluck(:exception_date).map { |d| d.iso8601 },
      doctor_blocked: for_doctor(doctor.id).where(slot_id: nil).pluck(:exception_date).map { |d| d.iso8601 }
    }
  end

  private

  def assign_doctor_unavailable_type
    self.exception_type = :doctor_unavailable if doctor.present?
  end
end
