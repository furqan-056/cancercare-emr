class Patients::AppointmentsController < Patients::BaseController
  before_action :find_doctor, only: [:new, :create, :edit, :update, :available_slots]
  before_action :find_appointment, only: [:edit, :update, :destroy]
  before_action :set_slots_and_exceptions, only: [:new, :edit]

  def index
    @q = policy_scope(Appointment).includes(:doctor, :slot).ransack(params[:q])
    @appointments = @q.result.recent_order_first.page(params[:page]).per(10)
  end

  def new
    @appointment = Appointment.new
  end

  def edit; end

  def create
    @appointment = current_user.appointments_as_patient.new(appointment_params.merge(doctor: @doctor))

    if @appointment.save
      flash[:notice] = "Appointment booked successfully"
      redirect_to patients_appointments_path
    else
      set_slots_and_exceptions
      render :new, status: :unprocessable_entity
    end
  end

  def update
  if @appointment.update(appointment_params)
     @appointment.send_updated_by_patient_email
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to patients_appointments_path, notice: "Appointment updated successfully" }
    end
    else
      set_slots_and_exceptions
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @appointment.destroy_by(current_user)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to patients_appointments_path, notice: "Appointment canceled successfully." }
    end
  end

  def available_slots
    date = Date.parse(params[:date])
    weekday_number = date.wday
    weekday_name = Slot.weekdays.key(weekday_number)

    @slots = Slot.where(doctor_id: @doctor.id, weekday: weekday_name).includes(:appointments, :slot_exceptions).ordered
    @selected_date = date
    global_exception = SlotException.where(exception_date: date, slot_id: nil).exists?

    @slot_availability = @slots.map do |slot|
      available = !global_exception && slot.available_on?(date)
      { id: slot.id, name: slot.display_name, available: available }
    end

    render partial: 'patients/appointments/slots_list', locals: { slots: @slot_availability, selected_date: @selected_date }
  end

  private

  def find_doctor
    @doctor = User.doctor.find(params[:doctor_id])
  end

  def find_appointment
    @appointment = current_user.appointments_as_patient.find(params[:id])
  end

  def set_slots_and_exceptions
    @slots = @doctor.slots.ordered
    @exceptions = SlotException.exceptions_for_calendar(@doctor)
  end

  def appointment_params
    params.require(:appointment).permit(:slot_id, :appointment_date, :reason)
  end
end
