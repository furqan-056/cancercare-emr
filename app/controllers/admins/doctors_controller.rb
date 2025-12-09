class Admins::DoctorsController < Admins::BaseController
  before_action :find_doctor, only: %i[edit update destroy]

  def index
    @q = Doctor.ransack(params[:q])
    @doctors = @q.result(distinct: true).page(params[:page]).per(10)
  end

  def edit
    authorize @doctor
  end

  def update
    authorize @doctor
    respond_to do |format|
      if @doctor.update(doctor_params)
        format.html { redirect_to admins_doctors_path, notice: "Doctor updated successfully." }
        format.turbo_stream { flash.now[:notice] = "Doctor updated successfully." }
      else
        format.html { render :edit }
        format.turbo_stream { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @doctor
    @doctor.destroy
    respond_to do |format|
      format.html { redirect_to admins_doctors_path, notice: "Doctor deleted successfully." }
      format.turbo_stream { flash.now[:notice] = "Doctor deleted successfully." }
    end
  end

  private

  def find_doctor
    @doctor = Doctor.find(params[:id])
  end

  def doctor_params
    params.require(:doctor).permit(:first_name, :last_name, :phone, :specialization, :department, :years_of_experience, :consultation_fee, :availability, :email,
      :role, :organization_id
    )
  end
end
