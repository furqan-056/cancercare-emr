class Appointment < ApplicationRecord
  belongs_to :slot
  belongs_to :doctor, class_name: "User"
  belongs_to :patient, class_name: "User"
  has_many_attached :pictures
  has_many_attached :pdfs


  validates :appointment_date, presence: true
  validates :slot_id, :reason, presence: true
  validates :slot_id, uniqueness: { scope: :appointment_date, message: "is already booked for this date",  conditions: -> { where.not(status: :rejected)  }}, if: :slot_present?
  validate :past_date
  validate :validate_pictures
  validate :validate_pdfs

  enum :status, { pending: 0, approved: 1, rejected: 2 }

  after_create_commit :send_created_email
  before_destroy :destroy_by_current_date

  scope :recent_order_first, -> { order(appointment_date: :desc) }

  def self.ransackable_attributes(auth_object = nil)
    ["appointment_date", "doctor_id", "patient_id", "reason", "slot_id", "status"]
  end

  def send_created_email
    AppointmentMailer.created(self).deliver_later
  end

  private

  def validate_pictures
    if pictures.attached?
      if pictures.count > 3
        errors.add(:pictures, "maximum 3 images allowed")
      end

      pictures.each do |picture|
        unless picture.content_type.in?(%w[image/png image/jpg image/jpeg])
          errors.add(:pictures, "must be PNG or JPG")
        end
      end
    end
  end

  def validate_pdfs
    if pdfs.attached?
      if pdfs.count > 1
        errors.add(:pdfs, "only one PDF allowed")
      end

      pdfs.each do |pdf|
        unless pdf.content_type == "application/pdf"
          errors.add(:pdfs, "must be a PDF file")
        end
      end
    end
  end

  def past_date
    if appointment_date < Date.current
      errors.add(:appointment_date, "cannot be in the past")
    end
  end

  def destroy_by_current_date
    if appointment_date == Date.current
      errors.add(:base, "You cannot delete an appointment scheduled for today")
      return false
    end

    destroy
  end

  def slot_present?
    slot_id.present? && appointment_date.present?
  end
end
