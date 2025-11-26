class Admins::UsersController < Admins::BaseController
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.order(created_at: :desc).page(params[:page]).per(10)
  end

  def new
    @user = User.new
  end

  def show; end

  def create
    @user = User.new(user_params)

    generated_password = SecureRandom.hex(10)
    @user.password = generated_password
    @user.password_confirmation = generated_password

    respond_to do |format|
      if @user.save
        @user.send_reset_password_instructions

        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend("users", partial: "user_row", locals: { user: @user }),
            turbo_stream.replace("modal", "")
          ]
        end

        format.html do
          redirect_to admins_users_path,
                      notice: "User created successfully. A password setup email has been sent."
        end
      else
        format.html { render :new, status: :unprocessable_entity }

        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_user_form",
            partial: "admins/users/form",
            locals: { user: @user }
          )
        end
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("user_#{@user.id}", partial: "user_row", locals: { user: @user }),
            turbo_stream.replace("modal", "")
          ]
        end

        format.html { redirect_to admins_users_path, notice: "User updated successfully." }
      else
        format.html { render :edit, status: :unprocessable_entity }

        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "edit_user_form",
            partial: "admins/users/form",
            locals: { user: @user }
          )
        end
      end
    end
  end

  def destroy
    @user.destroy
    redirect_to admins_users_path, notice: "User deleted successfully."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :role, :organization_id)
  end
end
