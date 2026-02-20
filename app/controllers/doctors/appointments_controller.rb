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
    if params[:appointment][:remove_picture_ids].present?
      params[:appointment][:remove_picture_ids].each do |id|
        picture = @appointment.pictures.find_by(id: id)
        picture.purge if picture
      end
    end

    if params[:appointment][:remove_pdf_ids].present?
      params[:appointment][:remove_pdf_ids].each do |id|
        pdf = @appointment.pdfs.find_by(id: id)
        pdf.purge if pdf
      end
    end

    if params[:appointment][:pictures].present?
      @appointment.pictures.attach(params[:appointment][:pictures])
    end

    if params[:appointment][:pdfs].present?
      @appointment.pdfs.attach(params[:appointment][:pdfs])
    end

    if @appointment.update(appointment_params.except(:pictures, :pdfs, :remove_picture_ids, :remove_pdf_ids))
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
    if @appointment.appointment_date == Date.current
      @appointment.errors.add(:base, "You cannot delete an appointment scheduled for today")
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to doctors_appointments_path, alert: @appointment.errors.full_messages.to_sentence }
      end
      return
    end

    @appointment.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to doctors_appointments_path, notice: "Appointment canceled successfully." }
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
    params.require(:appointment).permit(:appointment_date, :slot_id, :status, :patient_id, pictures: [],  pdfs: [], remove_picture_ids: [], remove_pdf_ids: [])
  end
end
