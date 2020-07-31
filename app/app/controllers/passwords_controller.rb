class PasswordsController < ApplicationController
  before_action :authenticate_spree_user!

  def update
    resource = Spree::Password.new(passwords_params)

    if resource.change
      sign_in(spree_current_user, bypass: true)

      render nothing: true
    else
      render json: resource.errors, status: :unprocessable_entity
    end
  end

  private

  def passwords_params
    p_params = params.require(:user).permit(:current_password, :password, :password_confirmation)
    p_params.merge(user: spree_current_user)
  end
end
