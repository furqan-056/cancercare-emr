class Admins::PatientsController < Admins::BaseController
  before_action :find_patient, only: %i[edit update destroy]

  def index
    @q = Patient.ransack(params[:q])
    @patients = @q.result(distinct: true).page(params[:page]).per(10)
  end

  def edit
    authorize @patient
  end

  def update
    authorize @patient
    respond_to do |format|
      if @patient.update(patient_params)
        format.html { redirect_to admins_patients_path, notice: "Patient updated successfully." }
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
      format.html { redirect_to admins_patients_path, notice: "Patient deleted successfully." }
      format.turbo_stream { flash.now[:notice] = "Patient deleted successfully." }
    end
  end

  private

  def find_patient
    @patient = Patient.find(params[:id])
  end

  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :phone, :email, :department, :role, :organization_id)
  end
end
