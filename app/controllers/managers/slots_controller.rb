class Managers::SlotsController < Managers::BaseController
  before_action :find_slot, only: %i[edit update destroy]

  def index
    @slots = Slot.ordered.page(params[:page]).per(10)
  end

  def new
    @slot = Slot.new
  end

  def create
    @slot = Slot.new(slot_params)
    if @slot.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to managers_slots_path }
      end
    else
      respond_to do |format|
        format.turbo_stream
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @slot.update(slot_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to managers_slots_path, notice: "Slot updated successfully" }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :edit, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @slot.destroy
    respond_to do |format|
      format.html { redirect_to managers_slots_path, notice: "Slot deleted" }
      format.turbo_stream
    end
  end

  private

  def find_slot
    @slot = Slot.find(params[:id])
  end

  def slot_params
    params.require(:slot).permit(:doctor_id, :weekday, :start_time, :end_time, :is_recurring)
  end
end
