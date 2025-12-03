class Managers::DoctorsController < Managers::BaseController
  before_action :find_doctor, only: %i[show edit update destroy]

  def index
    @q = policy_scope(Doctor).ransack(params[:q])
    @doctors = @q.result(distinct: true).page(params[:page]).per(10)
  end

  def show
    authorize @doctor
  end

  def new
    authorize Doctor
    @doctor = Doctor.new
  end

  def create
    @doctor = Doctor.new(doctor_params)
    authorize @doctor

    if params[:new_user_email].present?
      new_user = User.create!(
        email: params[:new_user_email],
        organization_id: current_user.organization_id,
        role: :doctor
      )
      @doctor.assign_new_user(new_user)
    end

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

  def edit
    authorize @doctor
    @doctor.build_user if @doctor.user.nil?
  end

  def update
    authorize @doctor
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
    authorize @doctor
    @doctor.destroy
    respond_to do |format|
      format.html { redirect_to managers_doctors_path, notice: "Doctor deleted successfully." }
      format.turbo_stream { flash.now[:notice] = "Doctor deleted successfully." }
    end
  end

  private

  def find_doctor
    @doctor = Doctor.find(params[:id])
  end

  def doctor_params
    params.require(:doctor).permit(:first_name, :last_name, :phone, :specialization, :department, :years_of_experience, :consultation_fee, :availability, :user_id,
    user_attributes: [:email])
  end
end
