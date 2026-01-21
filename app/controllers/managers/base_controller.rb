class Managers::BaseController < ApplicationController
  before_action :authenticate_user!

  private

  def find_and_authorize_slot
    @slot = policy_scope(Slot).find(params[:id])
    authorize @slot
  end
end
