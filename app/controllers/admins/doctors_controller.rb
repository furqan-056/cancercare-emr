class Admins::DoctorsController < Admins::BaseController
  before_action :find_and_authorize_doctor, only: %i[edit update destroy]

  def index
    @q = Doctor.ransack(params[:q])
    @doctors = @q.result(distinct: true).page(params[:page]).per(10)
  end

  def edit; end

  def update
    respond_to do |format|
      if @doctor.update(doctor_params)
        format.html { redirect_to admins_doctors_path, notice: "Doctor updated successfully." }
        format.turbo_stream { flash.now[:notice] = "Doctor updated successfully." }
      else
        format.html { render :edit }
        format.turbo_stream
      end
    end
  end

  def destroy
    if @doctor.destroy
      respond_to do |format|
        format.html { redirect_to admins_doctors_path, notice: "Doctor deleted successfully." }
        format.turbo_stream { flash.now[:notice] = "Doctor deleted successfully." }
      end
    else
      respond_to do |format|
        format.html { redirect_to admins_doctors_path, alert: "Doctor could not be deleted." }
        format.turbo_stream { flash.now[:alert] = "Doctor could not be deleted." }
      end
    end
  end

  private

  def find_and_authorize_doctor
    @doctor = authorize Doctor.find(params[:id])
  end

  def doctor_params
    params.require(:doctor).permit(:first_name, :last_name, :phone, :specialization, :department, :years_of_experience, :consultation_fee, :availability, :email, :role, :organization_id)
  end
end
