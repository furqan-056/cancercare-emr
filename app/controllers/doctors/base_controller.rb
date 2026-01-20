class Doctors::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_doctor!

  private

  def ensure_doctor!
    redirect_to root_path, alert: "Access denied" unless current_user&.doctor?
  end

  def find_and_authorize_slot
    @slot = policy_scope(Slot).find(params[:id])
    authorize @slot
  end

  def find_and_authorize_slot_exception
    @slot_exception = policy_scope(SlotException).find(params[:id])
    authorize @slot_exception
  end
end
