class SlotExceptionPolicy < ApplicationPolicy
  def index?
    user.manager? || user.doctor?
  end

  def create?
    index?
  end

  def update?
    user.manager? || (user.doctor? && record.doctor_id == user.id)
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      if user.manager?
        scope.all
      elsif user.doctor?
        scope.where(doctor_id: user.id)
      else
        scope.none
      end
    end
  end
end
