class DoctorPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.all if user.is_a?(Admin)

      if user.manager?
        scope.where(organization_id: user.organization_id)
      else
        scope.none
      end
    end
  end

  def show?
    user.is_a?(Admin) ||
      (user.manager? && record.organization_id == user.organization_id)
  end

  def create?
    user.is_a?(Admin) || user.manager?
  end

  def update?
    show?
  end

  def destroy?
    user.is_a?(Admin) ||
      (user.manager? && record.organization_id == user.organization_id)
  end
end
