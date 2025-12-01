class Admins::UsersController < Admins::BaseController
  before_action :find_user, only: %i[edit update destroy]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result.includes(:organization).order(created_at: :desc).page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        @user.send_reset_password_instructions
        format.html { redirect_to admins_users_path, notice: "User created successfully. A password setup email has been sent." }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to admins_users_path, notice: "User updated successfully." }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admins_users_path, notice: "User deleted successfully." }
      format.turbo_stream
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :role, :organization_id)
  end
end
