class Admins::OrganizationsController < Admins::BaseController
  before_action :set_organization, only: [:show, :edit, :update, :destroy]

  def index
    @organizations = current_admin.organizations
  end

  def show; end

  def new
    @organization = current_admin.organizations.new
  end

  def create
    @organization = current_admin.organizations.new(organization_params)
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
    @organization = current_admin.organizations.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name, :email, :organization_type, :phone_number)
  end
end
