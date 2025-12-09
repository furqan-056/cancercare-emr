class Doctors::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_doctor!

  layout "doctor"

  private

  def ensure_doctor!
    redirect_to root_path, alert: "Access denied" unless current_user&.doctor?
  end
end
