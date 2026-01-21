class Managers::SlotExceptionsController < Managers::BaseController
  before_action :find_slot_exception, only: %i[edit update destroy show]

  def index
    @q = SlotException.ransack(params[:q])
    @slot_exceptions = @q.result.includes(:doctor, :slot).recent_first.page(params[:page]).per(10)
  end

  def new
    @slot_exception = SlotException.new
  end

  def create
    @slot_exception = SlotException.new(slot_exception_params)
    authorize @slot_exception

    if @slot_exception.save
      flash.now[:notice] = "Slot Exception created successfully"
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to managers_slot_exceptions_path }
      end
    else
      respond_to do |format|
        format.turbo_stream
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def show; end

  def update
    if @slot_exception.update(slot_exception_params)
      flash.now[:notice] = "Slot Exception updated successfully"
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to managers_slot_exceptions_path }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :edit, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @slot_exception.destroy
    flash.now[:notice] = "Slot Exception deleted"
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to managers_slot_exceptions_path }
    end
  end

  private

  def find_slot_exception
    @slot_exception = policy_scope(SlotException).find(params[:id])
    authorize @slot_exception
  end

  def slot_exception_params
    params.require(:slot_exception).permit(:slot_id, :doctor_id, :exception_date, :exception_type, :reason)
  end
end
