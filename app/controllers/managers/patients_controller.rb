class Managers::PatientsController < Managers::BaseController
  before_action :find_patient, only: %i[show edit update destroy]
  before_action :authorize_patient, only: %i[show edit update destroy]

  def index
    @q = policy_scope(Patient).ransack(params[:q])
    @patients = @q.result(distinct: true).page(params[:page]).per(10)
  end

  def show; end

  def new
    authorize Patient
    @patient = Patient.new
  end

  def create
    authorize Patient
    @patient = current_user.organization.patients.build(patient_params)
    @patient.role = :patient

    respond_to do |format|
      if @patient.save
        format.html { redirect_to managers_patients_path, notice: "Patient created successfully." }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :create }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @patient.update(patient_params)
        format.html { redirect_to managers_patients_path, notice: "Patient updated successfully." }
        format.turbo_stream { flash.now[:notice] = "Patient updated successfully." }
      else
        format.html { render :edit }
        format.turbo_stream { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @patient.destroy

    respond_to do |format|
      format.html { redirect_to managers_patients_path, notice: "Patient deleted successfully." }
      format.turbo_stream { flash.now[:notice] = "Patient deleted successfully." }
    end
  end

  private

  def find_patient
    @patient = policy_scope(Patient).find(params[:id])
  end

  def authorize_patient
    authorize @patient
  end

  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :phone, :email, :department)
  end
end
