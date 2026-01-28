class SlotPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.manager?
        scope.joins(:doctor).where(users: { organization_id: user.organization_id })
      elsif user.doctor?
        scope.where(doctor_id: user.id)
      else
        scope.none
      end
    end
  end

  def show?
    user.manager? || user.doctor?
  end

  def create?
    show?
  end

  def new?
    show?
  end

  def update?
    show?
  end

  def destroy?
   show?
  end
end
