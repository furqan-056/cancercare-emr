class Managers::AppointmentsController < Managers::BaseController
  before_action :find_and_authorize_appointment, only: %i[show edit update destroy]

  def index
    @q_appointments = policy_scope(Appointment).ransack(params[:q_appointments])
    @appointments = @q_appointments.result.includes(:doctor, :patient, :slot).order(:date).page(params[:page]).per(10)

    @q_slots = policy_scope(Slot).ransack(params[:q_slots])
    @slots = @q_slots.result.includes(:doctor).order(:start_time).page(params[:slots_page]).per(10)
  end

  def show; end

  def new
    @appointment = Appointment.new
    authorize @appointment
  end

  def create
    @appointment = current_user.organization.appointments.new(appointment_params)
    @appointment.manager = current_user
    authorize @appointment

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to managers_appointment_path(@appointment), notice: "Appointment created successfully." }
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
        format.html { redirect_to managers_appointment_path(@appointment), notice: "Appointment updated successfully." }
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
      format.html { redirect_to managers_appointments_path, notice: "Appointment deleted successfully." }
      format.turbo_stream { flash.now[:notice] = "Appointment deleted successfully." }
    end
  end

  private

  def find_and_authorize_appointment
    @appointment = Appointment.find(params[:id])
    authorize @appointment
  end

  def appointment_params
    params.require(:appointment).permit(:patient_id, :slot_id, :status, :doctor_id)
  end
end
