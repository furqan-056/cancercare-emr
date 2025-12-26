class Doctors::AppointmentsController < Doctors::BaseController
  before_action :find_and_authorize_appointment, only: %i[show edit update destroy]

  def index
    @q = policy_scope(Appointment).where(doctor: current_user).ransack(params[:q_appointments])
    @appointments = @q.result.includes(:patient, :slot).order(date: :asc).page(params[:page]).per(10)
  end

  def show; end

  def new
    @appointment = Appointment.new(doctor: current_user,organization: current_user.organization)
    authorize @appointment
  end

  def create
    @appointment = current_user.organization.appointments.new(appointment_params.merge(doctor: current_user))
    authorize @appointment

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to doctors_appointment_path(@appointment), notice: "Appointment created successfully." }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to doctors_appointment_path(@appointment), notice: "Appointment updated successfully." }
        format.turbo_stream { flash.now[:notice] = "Appointment updated successfully." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  def destroy
    @appointment.destroy
    respond_to do |format|
      format.html { redirect_to doctors_appointments_path, notice: "Appointment deleted successfully." }
      format.turbo_stream { flash.now[:notice] = "Appointment deleted successfully." }
    end
  end

  private

  def find_and_authorize_appointment
    @appointment = Appointment.find(params[:id])
    authorize @appointment
  end

  def appointment_params
    params.require(:appointment).permit(:patient_id,:slot_id,:status)
  end
end
