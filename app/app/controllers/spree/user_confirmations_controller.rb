class Spree::UserConfirmationsController < Devise::ConfirmationsController
  helper 'spree/base', 'spree/store'

  helper 'spree/analytics' if Spree::Auth::Engine.dash_available?

  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Store

  def show
    super

    NewUserSubscriber.perform_async(resource.id) if resource.errors.empty?
  end

  protected

  def after_confirmation_path_for(resource_name, resource)
    signed_in?(resource_name) ? signed_in_root_path(resource) : spree.login_path
  end
end
