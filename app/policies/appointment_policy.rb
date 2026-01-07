class AppointmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.all if user.is_a?(Admin)

      if user.manager? || user.doctor?
        scope.where(organization_id: user.organization_id)
      else
        scope.none
      end
    end
  end

  def show?
    user.is_a?(Admin) || (user.manager? || user.doctor?)
  end

  def create?
    show?
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
