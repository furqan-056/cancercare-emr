class Admins::OrganizationsController < Admins::BaseController
  before_action :set_organization, only: [:show, :edit, :update, :destroy]
  layout 'admins'

  def index
    @organizations = Organization.all
  end

  def show; end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      redirect_to admins_organization_path(@organization), notice: "Organization created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @organization.update(organization_params)
      redirect_to admins_organization_path(@organization), notice: "Organization updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @organization.destroy
    redirect_to admins_organizations_path, notice: "Organization deleted successfully."
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admins_organizations_path, alert: "Organization not found."
  end

  def organization_params
    params.require(:organization).permit(:name, :email, :organization_type, :phone_number)
  end
end
