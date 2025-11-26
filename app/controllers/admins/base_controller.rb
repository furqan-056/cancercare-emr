module Admins
  class BaseController < ApplicationController
    include Pundit

    before_action :authenticate_admin!
    layout 'admins'
  end
end
