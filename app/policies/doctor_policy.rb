class DoctorPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_a?(Admin)
        scope.all
      elsif user.manager?
        scope.where(type: 'Doctor', organization_id: user.organization_id)
      else
        scope.none
      end
    end
  end

  def show?
    return true if user.is_a?(Admin)
    user.manager? && record.organization_id == user.organization_id
  end

  def create?
    user.is_a?(Admin) || user.manager?
  end

  def new?
    create?
  end

  def update?
    return true if user.is_a?(Admin)
    user.manager? && record.organization_id == user.organization_id
  end

  def edit?
    update?
  end

  def destroy?
    return true if user.is_a?(Admin)
    user.manager? && record.organization_id == user.organization_id
  end
end
