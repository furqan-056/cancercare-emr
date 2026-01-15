class Slot < ApplicationRecord
  belongs_to :doctor, class_name: "User"

  enum :weekday, { monday: 0, tuesday: 1, wednesday: 2, thursday: 3, friday: 4, saturday: 5 }

  validates :weekday, :start_time, :end_time, presence: true
  validate :end_time_after_start_time

  scope :ordered, -> { order(:weekday, :start_time) }

  private

  def end_time_after_start_time
    return if start_time.blank? || end_time.blank?
    errors.add(:end_time, "must be after start time") if end_time <= start_time
  end
end
