class Doctor < User
  validates :first_name, :last_name, :specialization, :department, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[first_name last_name phone specialization department years_of_experience consultation_fee availability email]
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
      new_doctor(params, organization_id)
    end
  end

  def self.from_existing_user(params, organization_id)
    user = User.find_by(id: params[:existing_user_id])

    if user
      doctor = user.becomes!(Doctor)
      doctor.assign_attributes(params.except(:existing_user_id))
      doctor.organization_id ||= organization_id
      doctor
    else
      new_doctor(params.except(:existing_user_id), organization_id)
    end
  end

  def self.new_doctor(params, organization_id)
    doctor = Doctor.new(params.except(:existing_user_id))
    doctor.organization_id = organization_id
    doctor
  end
end
