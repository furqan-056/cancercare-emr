class Patients::AppointmentsController < Patients::BaseController
  before_action :find_doctor, only: [:new, :create, :edit, :update, :available_slots]
  before_action :find_appointment, only: [:edit, :update, :destroy]
  before_action :set_slots_and_exceptions, only: [:new, :edit,  :create]

  def index
    @q = policy_scope(Appointment).includes(:doctor, slot: :doctor).ransack(params[:q])
    @appointments = @q.result.recent_order_first.page(params[:page]).per(10)
  end

  def new
    @appointment = Appointment.new
  end

  def edit; end

  def create
    @appointment = @doctor.appointments.new(appointment_params.merge(patient: current_user))
    @appointment.status ||= :pending

    if @appointment.save
      flash[:notice] = "Appointment booked successfully"
      redirect_to patients_appointments_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
  if @appointment.update(appointment_params)
    AppointmentMailer.updated_by_patient(@appointment).deliver_later
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to patients_appointments_path, notice: "Appointment updated successfully" }
    end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user.patient? && @appointment.appointment_date == Date.current
      @appointment.errors.add(:base, "You cannot delete an appointment scheduled for today")
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to patients_appointments_path, alert: @appointment.errors.full_messages.to_sentence }
      end
      return
    end

    @appointment.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to patients_appointments_path, notice: "Appointment canceled successfully." }
    end
  end

  def available_slots
    @selected_date = Date.parse(params[:date])
    @slots = Slot.where(doctor_id: @doctor.id, weekday: Slot.weekdays.key(@selected_date.wday)).includes(:doctor, :appointments, :slot_exceptions).ordered
    @slot_availability = @slots.map { |slot| slot.to_availability(@selected_date) }
    render layout: false
  end

  private

  def find_doctor
    @doctor = User.doctor.find(params[:doctor_id])
  end

  def find_appointment
    @appointment = current_user.appointments.find(params[:id])
  end

  def set_slots_and_exceptions
    @slots = @doctor.slots.ordered
    @exceptions = SlotException.exceptions_for_calendar(@doctor)
  end

  def appointment_params
    params.require(:appointment).permit(:slot_id, :appointment_date, :reason, :doctor_id)
  end
end
