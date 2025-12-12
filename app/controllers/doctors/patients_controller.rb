class Doctors::PatientsController < Doctors::BaseController
  before_action :find_patient, only: %i[show edit update destroy]
  before_action :authorize_patient, only: %i[show edit update destroy]

  def index
    @q = policy_scope(Patient).where(organization_id: current_user.organization_id, role: :patient).ransack(params[:q])
    @patients = @q.result(distinct: true).page(params[:page]).per(10)
  end

  def show; end

  def new
    authorize Patient
    @patient = Patient.new
  end

  def edit; end

  def update
    respond_to do |format|
      if @patient.update(patient_params)
        format.html { redirect_to doctors_patients_path,
                      notice: "Patient updated successfully." }
        format.turbo_stream { flash.now[:notice] = "Patient updated successfully." }
      else
        format.html { render :edit }
        format.turbo_stream {
          render :edit, status: :unprocessable_entity
        }
      end
    end
  end

  private

  def find_patient
    @patient = policy_scope(Patient)
                .where(organization_id: current_user.organization_id)
                .find(params[:id])
  end

  def authorize_patient
    authorize @patient
  end

  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :phone, :email, :department)
  end
end
