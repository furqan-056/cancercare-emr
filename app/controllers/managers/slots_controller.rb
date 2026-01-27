class Managers::SlotsController < Managers::BaseController
  before_action :find_and_authorize_slot, only: %i[edit update destroy]

  def index
    @slots = policy_scope(Slot).ordered.page(params[:page]).per(10)
  end

  def new
    @slot = Slot.new
    authorize @slot
  end

  def create
    @slot = Slot.new(slot_params)
    authorize @slot

    if @slot.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to managers_slots_path, notice: "Slot created successfully" }
      end
    else
      respond_to do |format|
        format.turbo_stream
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    if @slot.update(slot_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to managers_slots_path, notice: "Slot updated successfully" }
      end
    else
      respond_to do |format|
        format.turbo_stream
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @slot.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to managers_slots_path, notice: "Slot deleted successfully" }
    end
  end

  private

  def slot_params
    params.require(:slot).permit(:doctor_id, :weekday, :start_time, :end_time, :is_recurring)
  end
end
