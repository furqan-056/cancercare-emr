class Admins::OrganizationsController < Admins::BaseController
  before_action :set_organization, only: %i[show edit update destroy]

  def index
    @organizations = Organization.all
  end

  def show; end

  def new
    @organization = Organization.new
    @organization.build_address
  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      redirect_to admins_organization_path(@organization), notice: "Organization created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @organization.build_address unless @organization.address
  end

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
    params.require(:organization).permit(
      :name, 
      :email, 
      :organization_type, 
      :phone_number, 
      :logo,
      address_attributes: [
        :id,
        :street_address,
        :location,
        :city,
        :postal_code,
        :country,
        :_destroy
      ]
    )
  end
end
