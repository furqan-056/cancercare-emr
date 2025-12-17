class Admins::PatientsController < Admins::BaseController
  before_action :find_and_authorize_patient, only: %i[edit update destroy]

  def index
    @q = Patient.ransack(params[:q])
    @patients = @q.result(distinct: true).page(params[:page]).per(10)
  end

  def edit; end

  def update
    respond_to do |format|
      if @patient.update(patient_params)
        format.html { redirect_to admins_patients_path, notice: "Patient updated successfully." }
        format.turbo_stream { flash.now[:notice] = "Patient updated successfully." }
      else
        format.html { render :edit }
        format.turbo_stream { flash.now[:notice] = "Patient Updated successfully." }
      end
    end
  end

  def destroy
    if @patient.destroy
      respond_to do |format|
        format.html { redirect_to admins_patients_path, notice: "Patient deleted successfully." }
        format.turbo_stream { flash.now[:notice] = "Patient deleted successfully." }
      end
    else
      respond_to do |format|
        format.html { redirect_to admins_patients_path, alert: "Patient could not be deleted." }
        format.turbo_stream { flash.now[:alert] = "Patient could not be deleted." }
      end
    end
  end

  private

  def find_and_authorize_patient
    @patient = Patient.find(params[:id])
    authorize @patient
  end

  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :phone, :email, :department, :role, :organization_id)
  end
end
