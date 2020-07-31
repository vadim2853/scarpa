class Spree::UserSessionsController < Devise::SessionsController
  helper 'spree/base', 'spree/store'
  helper 'spree/analytics' if Spree::Auth::Engine.dash_available?

  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Store

  after_action :finalize_grade, only: :create

  def new
    redirect_to '/'
  end

  def create
    authenticate_spree_user!

    respond_to do |format|
      format.js do
        if spree_user_signed_in?
          render json: { url: path_after_sign_in_up }
        else
          render json: Spree.t('auth_invalid'), status: :unprocessable_entity
        end
      end
    end
  end
end
