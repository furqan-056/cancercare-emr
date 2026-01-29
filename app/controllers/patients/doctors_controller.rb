class Patients::DoctorsController < Patients::BaseController
  def index
    @q = policy_scope(Doctor).ransack(params[:q])
    @doctors = @q.result(distinct: true).order(:first_name).page(params[:page]).per(9)
  end
end
