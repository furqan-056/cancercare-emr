class Managers::DoctorsController < Managers::BaseController
  before_action :find_doctor, only: %i[show edit update destroy]
  before_action :authorize_doctor, only: %i[show edit update destroy]

  def index
    @q = policy_scope(Doctor)
          .where(organization_id: current_user.organization_id, role: "doctor")
          .ransack(params[:q])

    @doctors = @q.result(distinct: true).page(params[:page]).per(10)
  end

  def new
    authorize Doctor
    @doctor = Doctor.new
  end

  def create
    authorize Doctor

    @doctor = Doctor.new(doctor_params)
    @doctor.organization_id = current_user.organization_id
    @doctor.role = "doctor"

    respond_to do |format|
      if @doctor.save
        format.html { redirect_to managers_doctors_path, notice: "Doctor created successfully." }
        format.turbo_stream { flash.now[:notice] = "Doctor created successfully." }
      else
        format.html { render :new }
        format.turbo_stream { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show; end

  def edit; end

  def update
    respond_to do |format|
      if @doctor.update(doctor_params)
        format.html { redirect_to managers_doctors_path, notice: "Doctor updated successfully." }
        format.turbo_stream { flash.now[:notice] = "Doctor updated successfully." }
      else
        format.html { render :edit }
        format.turbo_stream { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @doctor.destroy
    respond_to do |format|
      format.html { redirect_to managers_doctors_path, notice: "Doctor deleted successfully." }
      format.turbo_stream { flash.now[:notice] = "Doctor deleted successfully." }
    end
  end

  private

  def find_doctor
    @doctor = policy_scope(Doctor)
                .where(organization_id: current_user.organization_id)
                .find(params[:id])
  end

  def authorize_doctor
    authorize @doctor
  end

  def doctor_params
    params.require(:doctor).permit(:first_name, :last_name, :phone, :specialization, :department, :years_of_experience, :consultation_fee, :availability, :email)
  end
end
