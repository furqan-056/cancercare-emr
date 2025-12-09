class Doctors::PatientsController < Doctors::BaseController
  before_action :find_patient, only: %i[show edit update destroy]

  def index
    @q = policy_scope(Patient).where(organization_id: current_user.organization_id, role: "patient").ransack(params[:q])
    @patients = @q.result(distinct: true).page(params[:page]).per(10)
  end

  def show
    authorize @patient
  end

  def new
    authorize Patient
    @patient = Patient.new
  end

  def create
    authorize Patient
    @patient = Patient.build_for_create(patient_params, current_user.organization_id)

    respond_to do |format|
      if @patient.save
        format.html { redirect_to doctors_patients_path, notice: "Patient created successfully." }
        format.turbo_stream { flash.now[:notice] = "Patient created successfully." }
      else
        Rails.logger.info "Patient creation failed: #{@patient.errors.full_messages.join(', ')}"
        format.html { render :new }
        format.turbo_stream { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize @patient
  end

  def update
    authorize @patient

    respond_to do |format|
      if @patient.update(patient_params)
        format.html { redirect_to doctors_patients_path, notice: "Patient updated successfully." }
        format.turbo_stream { flash.now[:notice] = "Patient updated successfully." }
      else
        format.html { render :edit }
        format.turbo_stream { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @patient
    @patient.destroy
    respond_to do |format|
      format.html { redirect_to doctors_patients_path, notice: "Patient deleted successfully." }
      format.turbo_stream { flash.now[:notice] = "Patient deleted successfully." }
    end
  end

  private

  def find_patient
    @patient = Patient.where(organization_id: current_user.organization_id).find(params[:id])
  end

  def patient_params
    permitted = [:first_name, :last_name, :phone, :email, :department]
    permitted << :existing_user_id if action_name == "create"
    params.require(:patient).permit(permitted)
  end
end
