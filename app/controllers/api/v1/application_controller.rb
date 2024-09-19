class Api::V1::ApplicationController < ApplicationController

  include Pundit::Authorization
  rescue_from ::Pundit::NotAuthorizedError, with: :render_forbidden

  # NOTE: skipped as out of scope
  # before_action :authenticate_token_user!

  private

  def pundit_user
    current_customer
  end

  def render_forbidden
    render json: { success: false, errors: "Forbidden - The resource requested is not accessible" }, status: 403
  end

end
