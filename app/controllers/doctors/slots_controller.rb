class Doctors::SlotsController < Doctors::BaseController
  before_action :find_and_authorize_slot, only: %i[edit update destroy]

  def index
    @slots = policy_scope(Slot).ordered.page(params[:page]).per(8)
  end

  def new
    @slot = Slot.new
  end

  def create
    @slot = Slot.new(slot_params.merge(doctor: current_user))
    authorize @slot

    if @slot.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to doctors_slots_path, notice: "Slot created successfully" }
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
        format.html { redirect_to doctors_slots_path, notice: "Slot updated successfully" }
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
      format.html { redirect_to doctors_slots_path, notice: "Slot deleted" }
    end
  end

  private

  def slot_params
    params.require(:slot).permit(:weekday, :start_time, :end_time, :is_recurring)
  end
end
