class Slot < ApplicationRecord
  belongs_to :doctor, class_name: "User"
  has_many :slot_exceptions, dependent: :destroy

  enum :weekday, { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 }

  validates :weekday, :start_time, :end_time, presence: true
  validate :end_time_after_start_time

  scope :ordered, -> { order(:weekday, :start_time) }

  def display_name
    "#{weekday.titleize} #{start_time.strftime('%H:%M')} - #{end_time.strftime('%H:%M')} (#{doctor.full_name})"
  end

  private

  def end_time_after_start_time
    if end_time&.<= (start_time)
      errors.add(:end_time, "must be after start time")
    end
  end
end
