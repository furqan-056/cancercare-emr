class Managers::SlotsController < Managers::BaseController
  before_action :find_and_authorize_slot, only: %i[show edit update destroy]

  def show; end

  def new
    @slot = Slot.new
    authorize @slot
  end

  def create
    @slot = current_user.organization.slots.new(slot_params)
    authorize @slot

    respond_to do |format|
      if @slot.save
        format.html { redirect_to managers_appointments_path, notice: "Slot created successfully." }
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
      if @slot.update(slot_params)
        format.html { redirect_to managers_appointments_path, notice: "Slot updated successfully." }
        format.turbo_stream { flash.now[:notice] = "Slot updated successfully." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  def destroy
    @slot.destroy
      respond_to do |format|
        format.html { redirect_to managers_appointments_path, notice: "Slot deleted successfully." }
        format.turbo_stream { flash.now[:notice] = "Slot deleted successfully." }
    end
  end

  private

  def find_and_authorize_slot
    @slot = Slot.find(params[:id])
    authorize @slot
  end

  def slot_params
    params.require(:slot).permit(:doctor_id, :start_time, :end_time, :available)
  end
end
