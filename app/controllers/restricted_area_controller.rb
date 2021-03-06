class RestrictedAreaController < ApplicationController

  before_action :authenticate_user!
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
  layout 'application'

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    respond_to do |f|
      f.json {
        render json: { success: false, error: 'Unauthorized' }, status: :unauthorized
      }
      f.html {
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to(request.referrer || root_path)
      }
    end

  end
end