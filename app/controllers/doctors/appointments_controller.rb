class Doctors::AppointmentsController < Doctors::BaseController
  before_action :find_appointment_and_authorize, only: [:show, :edit, :update, :destroy]
  before_action :load_slots, only: [:edit, :update]

  def index
    @q = policy_scope(Appointment).ransack(params[:q])
    @appointments = @q.result.includes(:patient, :doctor, :slot).recent_order_first.page(params[:page]).per(10)
  end

  def edit; end
  def show; end

  def update
    if @appointment.update(appointment_params)
       @appointment.send_status_email if @appointment.saved_change_to_status?
      flash.now[:notice] = "Appointment updated successfully"
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to doctors_appointments_path }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    handle_unique_slot_error
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

  def handle_unique_slot_error
    @appointment.errors.add(:base, "This slot is already booked for this date")
    render :edit, status: :unprocessable_entity
  end

  def find_appointment_and_authorize
    @appointment = Appointment.find(params[:id])
    authorize @appointment
  end

  def appointment_params
    params.require(:appointment).permit(:appointment_date, :slot_id, :status, :patient_id)
  end
end
