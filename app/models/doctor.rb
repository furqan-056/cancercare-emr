class Doctor < ApplicationRecord
  belongs_to :user, optional: true

  validates :user_id, presence: true, unless: -> { @creating_new_user }

  def assign_new_user(user)
    self.user = user
    @creating_new_user = true
  end

  def self.ransackable_attributes(auth_object = nil)
    ["availability", "consultation_fee", "department", "first_name", "last_name", "phone", "specialization", "years_of_experience"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end
end
