class PatientPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      return scope.all if user.is_a?(Admin)

      if user.manager?
        scope.where(organization_id: user.organization_id)

      elsif user.doctor?
        scope.where(organization_id: user.organization_id)

      else
        scope.none
      end
    end
  end

  def show?
    user.is_a?(Admin) || user.manager? || user.doctor?
  end


  def create?
    user.is_a?(Admin) || user.manager?
  end


  def new?
    create?
  end


  def update?
    user.is_a?(Admin) || user.manager? ||
      user.doctor?
  end


  def destroy?
    user.is_a?(Admin) || user.manager? || user.doctor?
  end
end
