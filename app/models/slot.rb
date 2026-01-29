class Slot < ApplicationRecord
  has_paper_trail
  belongs_to :doctor, class_name: "User"
  has_many :slot_exceptions, dependent: :destroy
  has_many :appointments, dependent: :destroy

  enum :weekday, { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 }

  validates :weekday, :start_time, :end_time, presence: true
  validate :end_time_after_start_time, :no_overlapping_slots

  scope :ordered, -> { order(:weekday, :start_time) }
  scope :for_weekday, ->(day) { where(weekday: day) }

  def available_on?(date)
    return false unless is_recurring
    return false unless date.wday == self.class.weekdays[weekday]

    return false if slot_exceptions.any? do |e|
      e.exception_date == date && e.slot_id.nil? && e.doctor_id == doctor.id
    end

    return false if slot_exceptions.any? do |e|
      e.exception_date == date && e.slot_id == id
    end

    return false if appointments.any? do |a|
      a.appointment_date == date && (a.pending? || a.approved?)
    end

    true
  end

  def display_name
    "#{weekday.titleize} #{start_time.strftime('%H:%M')} - #{end_time.strftime('%H:%M')} (#{doctor.full_name})"
  end

  private

  def no_overlapping_slots
    overlapping_slot = Slot.where(doctor_id: doctor.id, weekday: weekday).where("start_time < ? AND end_time > ?", end_time, start_time).exists?
    errors.add(:base, "This slot overlaps with another slot for the same doctor") if overlapping_slot
  end

  def end_time_after_start_time
    if end_time&.<= (start_time)
      errors.add(:end_time, "must be after start time")
    end
  end
end
