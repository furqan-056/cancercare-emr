class PatientPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_a?(Admin)
        scope.all
      else
        scope.where(organization_id: user.organization_id)
      end
    end
  end

  def index?
    return true if user.is_a?(Admin)
    user.manager? || user.doctor?
  end

  def show?
    return true if user.is_a?(Admin)
    (user.manager? || user.doctor?) &&
      record.organization_id == user.organization_id
  end

  def create?
    return true if user.is_a?(Admin)
    user.manager? || user.doctor?
  end

  def new?
    create?
  end

  def update?
    return true if user.is_a?(Admin)
    (user.manager? || user.doctor?) &&
      record.organization_id == user.organization_id
  end

  def edit?
    update?
  end

  def destroy?
    return true if user.is_a?(Admin)
    (user.manager? || user.doctor?) &&
      record.organization_id == user.organization_id
  end
end
