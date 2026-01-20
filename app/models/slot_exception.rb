class SlotException < ApplicationRecord
  belongs_to :slot, optional: true
  belongs_to :doctor, class_name: "User", optional: true

  enum :exception_type, { holiday: 0, doctor_unavailable: 1, blocked_date: 2 }
  attr_accessor :current_user

  validates :reason, presence: true
  validates :exception_date, uniqueness: { scope: :slot_id, message: "already has an exception for this specific slot" }, if: -> { slot_id.present? }
  before_validation :set_exception_type_for_doctor, on: :create

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
    exists?(["(slot_id = ? OR slot_id IS NULL) AND (doctor_id IS NULL OR doctor_id = ?) AND exception_date = ?", slot_id, doctor_id, date])
  end

  private

def set_exception_type_for_doctor
    if current_user&.doctor?
      self.exception_type = "doctor_unavailable"
      self.doctor_id = current_user.id
    end
  end
end
