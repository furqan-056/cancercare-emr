class DoctorPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_a?(Admin)
        scope.all
      else
        scope.joins(:user)
             .where(users: { role: :doctor, organization_id: user.organization_id })
      end
    end
  end

  def show?
    return true if user.is_a?(Admin)
    user.manager? && record.user.organization_id == user.organization_id
  end

  def create?
    user.is_a?(Admin) || user.manager?
  end

  def new?
    create?
  end

  def update?
    return true if user.is_a?(Admin)
    user.manager? && record.user.organization_id == user.organization_id
  end

  def edit?
    update?
  end

  def destroy?
    return true if user.is_a?(Admin)
    user.manager? && record.user.organization_id == user.organization_id
  end
end
