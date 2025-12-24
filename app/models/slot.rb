class Slot < ApplicationRecord
  belongs_to :organization
  belongs_to :doctor, class_name: "User"
  has_one :appointment, dependent: :destroy

  scope :available, -> { where(available: true) }

  validates :start_time, :end_time, presence: true
  validate  :start_time_before_end_time
  validate  :no_overlapping_slots

  def self.ransackable_attributes(auth_object = nil)
    %w[available start_time end_time]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[doctor]
  end

  private

  def start_time_before_end_time
    return if start_time.blank? || end_time.blank?
    if start_time >= end_time
      errors.add(:start_time, "must be before end time")
    end
  end

  def no_overlapping_slots
    return if start_time.blank? || end_time.blank?

    overlapping = Slot.where(doctor_id: doctor_id).where.not(id: id).where("start_time < ? AND end_time > ?", end_time, start_time)

    if overlapping.exists?
      errors.add(:base, "This slot overlaps with another slot for the same doctor")
    end
  end
end
