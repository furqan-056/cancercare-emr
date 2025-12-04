class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_current_organization
  include Pundit

  private

  def set_current_organization
    return if request.subdomain.blank? || %w[www admin].include?(request.subdomain)

    @current_organization = Organization.find_by(slug: request.subdomain)
    redirect_to root_url(subdomain: nil), alert: "Organization not found" unless @current_organization
  end

  def after_sign_in_path_for(resource)
    if resource.manager?
      managers_dashboard_url(host: "#{resource.organization.slug}.localhost", allow_other_host: true)
    elsif resource.is_a?(Admin)
      admins_dashboard_url(allow_other_host: true)
    else
      super
    end
  end

  def after_resetting_password_path_for(resource)
    return managers_dashboard_path if resource.manager?

    super
  end
end
