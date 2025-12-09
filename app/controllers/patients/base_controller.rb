class Patients::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_patient

    layout "patient"

  private

  def ensure_patient
    redirect_to root_path, alert: "Access denied" unless current_user&.patient?
  end
end
