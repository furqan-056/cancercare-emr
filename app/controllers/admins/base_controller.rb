module Admins
  class BaseController < ApplicationController

    before_action :authenticate_admin!
    layout 'admins'
  end
end
