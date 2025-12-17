class Users::SessionsController < Devise::SessionsController
  def create
    organization = Organization.find_by(slug: request.subdomain)

    unless organization
      redirect_to root_url(subdomain: nil), alert: "Invalid organization" and return
    end

    user = User.find_by(email: params[:user][:email])
    if user && user.organization_id != organization.id
      redirect_to new_user_session_url(subdomain: organization.slug), alert: "You must log in from your organization's domain" and return
    end

    super
  end
end
