class Patients::AppointmentsController < Patients::BaseController
  before_action :find_doctor, only: [:new, :create, :edit, :update, :available_slots]
  before_action :find_appointment, only: [:edit, :update, :destroy]
  before_action :set_slots_and_exceptions, only: [:new, :edit,  :create]

  def index
    @q = policy_scope(Appointment).includes(:doctor, :slot).ransack(params[:q])
    @appointments = @q.result.recent_order_first.page(params[:page]).per(10)
  end

  def new
    @appointment = Appointment.new
  end

  def edit; end

  def create
    @appointment = current_user.appointments.new(appointment_params)
    @appointment.doctor = @doctor
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
      AppointmentMailer.updated_by_patient(@appointment).deliver_later(wait: 10.seconds)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to patients_appointments_path, notice: "Appointment updated successfully" }
    end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @appointment.current_user_for_destroy = current_user
    @appointment.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to patients_appointments_path, notice: "Appointment canceled successfully." }
    end
  end

  def available_slots
    date = Date.parse(params[:date])
    weekday_name = Slot.weekdays.key(date.wday)
    @slots = Slot.where(doctor_id: @doctor.id, weekday: weekday_name).includes(:appointments, :slot_exceptions).ordered
    @selected_date = date

    @slot_availability = @slots.map do |slot|
      { id: slot.id, name: slot.display_name, available: slot.available_on?(date) }
    end

    render partial: 'patients/appointments/slots_list', locals: { slots: @slot_availability, selected_date: @selected_date }
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
