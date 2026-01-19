class Slot < ApplicationRecord
  belongs_to :doctor, class_name: "User"
  has_many :slot_exceptions, dependent: :destroy

  enum :weekday, { monday: 0, tuesday: 1, wednesday: 2, thursday: 3, friday: 4, saturday: 5 }

  validates :weekday, :start_time, :end_time, presence: true
  validate :end_time_after_start_time

  scope :ordered, -> { order(:weekday, :start_time) }

  def available_on?(date)
    return false unless is_recurring
    return false unless date.wday == Slot.weekdays[weekday]

    return false if SlotException.holiday?(date)

    return false if SlotException.doctor_unavailable?(doctor_id, date)

    return false if SlotException.slot_blocked?(id, date)

    return false if appointments.exists?(appointment_date: date)

    true
  end

  def display_name
    "#{weekday.titleize} #{start_time.strftime('%H:%M')} - #{end_time.strftime('%H:%M')} (#{doctor.full_name})"
  end

  private

  def end_time_after_start_time
    errors.add(:end_time, "must be after start time") if end_time <= start_time
  end
end
