class Patient < User
  validates :first_name, :last_name, :department, presence: true
  has_many :appointments_as_patient, class_name: 'Appointment', foreign_key: 'patient_id'

  def self.ransackable_attributes(_auth = nil)
    %w[first_name last_name phone department email]
  end

  def self.ransackable_associations(_auth = nil)
    ["organization"]
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
