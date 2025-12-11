class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_current_organization
  include Pundit

  def pundit_user
    if defined?(current_admin) && current_admin
      current_admin
    else
      current_user
    end
  end

  private

  def set_current_organization
    return if request.subdomain.blank? || %w[www admin].include?(request.subdomain)

    @current_organization = Organization.find_by(slug: request.subdomain)
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      admins_dashboard_path
    elsif resource.is_a?(User)
      case resource.role
      when "manager"
        managers_dashboard_url(host: "#{resource.organization.slug}.localhost", allow_other_host: true)
      when "doctor"
        doctors_dashboard_url(host: "#{resource.organization.slug}.localhost", allow_other_host: true)
      when "patient"
        patients_dashboard_path
      else
        root_path
      end
    else
      root_path
    end
  end

  def after_resetting_password_path_for(resource)
    return managers_dashboard_path if resource.manager?
    return doctors_dashboard_path if resource.doctor?

    super
  end
end
