class Managers::ResourcesController < Managers::BaseController
  before_action :set_resource_classes

  def index
  @q_appointments = policy_scope(@appointment_class).ransack(params[:q_appointments])
  @appointments = @q_appointments.result.includes(:doctor, :patient, :slot).order(:date).page(params[:page]).per(10)

  @q_slots = policy_scope(@slot_class).ransack(params[:q_slots])
  @slots = @q_slots.result.includes(:doctor).order(:start_time).page(params[:slots_page]).per(10)

    render "managers/appointments/index"
  end

  private

  def set_resource_classes
    @appointment_class = Appointment
    @slot_class = Slot
  end
end
