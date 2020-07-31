class Spree::UserRegistrationsController < Devise::RegistrationsController
  helper 'spree/base', 'spree/store'
  helper 'spree/analytics' if Spree::Auth::Engine.dash_available?

  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Store

  skip_before_action :require_no_authentication
  after_action :finalize_grade, only: :create

  def create
    build_resource(spree_user_params)

    respond_to do |format|
      format.js do
        if resource.save
          sign_in(:spree_user, resource)
          session[:spree_user_signup] = true
          associate_user
          Spree::UserMailer.welcome_email(spree_current_user).deliver_later unless Rails.env.test?
          render json: { url: path_after_sign_in_up }
        else
          clean_up_passwords(resource)
          render json: resource.errors, status: :unprocessable_entity
        end
      end
    end
  end

  protected

  def translation_scope
    'devise.user_registrations'
  end

  private

  def spree_user_params
    data = params.require(:spree_user)
                 .permit(Spree::PermittedAttributes.user_attributes | [:email] | [:spree_role_ids])

    unless params[:spree_user].include? :role_selected
      data[:spree_role_ids] = Spree::Role.find_by(name: 'user', category: 'default').id
    end

    data
  end
end
