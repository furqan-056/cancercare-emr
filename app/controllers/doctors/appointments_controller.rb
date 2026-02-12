class Doctors::AppointmentsController < Doctors::BaseController
  before_action :find_and_authorize_appointment, only: [:show, :edit, :update, :destroy]
  before_action :load_slots, only: [:edit, :update]

  def index
    @q = policy_scope(Appointment).ransack(params[:q])
    @appointments = @q.result.includes(:patient, :doctor, slot: :doctor).recent_order_first.page(params[:page]).per(10)
  end

  def edit; end

  def show; end

  def update
    if @appointment.update(appointment_params)
      AppointmentMailer.status_changed(@appointment).deliver_later if @appointment.saved_change_to_status?
      flash.now[:notice] = "Appointment updated successfully"
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to doctors_appointments_path }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @appointment.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to doctors_appointments_path, notice: "Appointment removed successfully" }
    end
  end

  private

  def load_slots
    @slots = current_user.slots.ordered
  end

  def find_and_authorize_appointment
    @appointment = Appointment.find(params[:id])
    authorize @appointment
  end

  def appointment_params
    params.require(:appointment).permit(:appointment_date, :slot_id, :status, :patient_id)
  end
end
