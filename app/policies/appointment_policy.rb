class AppointmentPolicy < ApplicationPolicy
  def create?
    user.patient?
  end

  def show?
    update?
  end

  def edit?
    update?
  end

  def update?
    record.patient == user || record.doctor == user
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      if user.patient?
        scope.where(patient: user)
      elsif user.doctor?
        scope.where(doctor: user)
      else
        scope.none
      end
    end
  end
end
