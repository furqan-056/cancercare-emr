class Managers::ResourcesController < Managers::BaseController
  def index
    @q_appointments = policy_scope(Appointment).ransack(params[:q_appointments])
    @appointments = @q_appointments.result.includes(:doctor, :patient, :slot).order(:date).page(params[:page]).per(10)

    @q_slots = policy_scope(Slot).ransack(params[:q_slots])
    @slots = @q_slots.result.includes(:doctor).order(:start_time).page(params[:slots_page]).per(10)

    render "managers/appointments/index"
  end
end
