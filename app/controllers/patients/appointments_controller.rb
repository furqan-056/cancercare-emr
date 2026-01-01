class Patients::AppointmentsController < Patients::BaseController
  def index
    @q = current_user.organization.doctors.ransack(params[:q])
    @doctors = @q.result.page(params[:page]).per(9)

    @appointments_by_doctor = current_user.patient_appointments.pluck(:doctor_id, :status).to_h
  end

  def create
    doctor = current_user.organization.users.find(params[:doctor_id])
    appointment = Appointment.request_by_patient(patient: current_user, doctor: doctor)

    if appointment.persisted?
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to patients_appointments_path, notice: "Appointment requested successfully." }
      end
    else
      redirect_to patients_appointments_path, alert: appointment.errors.full_messages.join(", ")
    end
  end
end
