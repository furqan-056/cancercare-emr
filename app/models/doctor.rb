class Doctor < User
  validates :first_name, :last_name, :specialization, :department, presence: true

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
