class Ui::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token

  private

  def respond_with_interaction(klass, options = {})
    render json: klass.new(user: spree_current_user, params: params, options: options)
  end

  def require_authentication
    head 401 if current_user.blank?
  end

  def current_user
    current_spree_user || spree_current_user
  end
end
