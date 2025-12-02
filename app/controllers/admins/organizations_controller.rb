class Admins::OrganizationsController < Admins::BaseController
  before_action :set_organization, only: %i[show edit update destroy]

  def index
    @q = Organization.ransack(params[:q])
    @organizations = @q.result.includes(:address, :users).order(created_at: :desc).page(params[:page]).per(5)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show; end

  def new
    @organization = Organization.new
    @organization.build_address
    @organization.users.build
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def create
    @organization = Organization.new(organization_params)
    respond_to do |format|
      if @organization.save
        format.html do
          redirect_to admins_organization_path(@organization), notice: "Organization created successfully. New users will receive an email to set their password."
        end
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  def edit
    @organization.build_address unless @organization.address
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html do
          redirect_to admins_organization_path(@organization),
                      notice: "Organization updated successfully. New users will receive an email to set their password."
        end
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  def destroy
    @organization.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to admins_organizations_path, notice: "Organization deleted successfully." }
    end
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admins_organizations_path, alert: "Organization not found."
  end
  
  def organization_params
    params.require(:organization).permit(:name, :email, :organization_type, :phone_number, :logo,
      address_attributes: %i[id street_address location city postal_code country _destroy],
      users_attributes: %i[id email role _destroy])
  end
end
