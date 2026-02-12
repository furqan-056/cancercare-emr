class Doctor < User
  validates :first_name, :last_name, :specialization, :department, presence: true
  has_many :slots, dependent: :destroy
  has_many :slot_exceptions, foreign_key: :doctor_id, dependent: :destroy
  has_many :appointments, foreign_key: :doctor_id, class_name: "Appointment", dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    %w[first_name last_name phone specialization department years_of_experience consultation_fee availability email role]
  end

  def self.ransackable_associations(auth_object = nil)
    ["organization"]
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
