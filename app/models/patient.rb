class Patient < User
  validates :first_name, :last_name, :department, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[first_name last_name phone department email]
  end

  def self.ransackable_associations(auth_object = nil)
    ["organization"]
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.build_for_create(params, organization_id)
    if params[:existing_user_id].present?
      from_existing_user(params, organization_id)
    else
      new_patient(params, organization_id)
    end
  end

  def self.from_existing_user(params, organization_id)
    user = User.find_by(id: params[:existing_user_id])

    if user
      patient = user.becomes!(Patient)
      patient.assign_attributes(params.except(:existing_user_id))
      patient.organization_id ||= organization_id
      patient.role ||= :patient
      patient
    else
      new_patient(params.except(:existing_user_id), organization_id)
    end
  end

  def self.new_patient(params, organization_id)
    patient = Patient.new(params.except(:existing_user_id))
    patient.organization_id = organization_id
    patient.role = :patient
    patient
  end
end
