module Admins
  class DashboardsController < ApplicationController
    before_action :authenticate_admin!
    
    def index
      @admin_email = current_admin.email
    end
  end
end
