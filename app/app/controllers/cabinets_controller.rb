class CabinetsController < StoreController
  before_action :authenticate_spree_user!, only: [:index, :edit, :update, :avatar_upload]

  def index
    @years = spree_current_user.years_of_completed_orders

    if @years.present?
      year = params[:year] || @years.first
      @months = spree_current_user.months_of_completed_orders_by(year: year)
      @orders = spree_current_user.completed_orders_by(year: year, month: (params[:month] || @months.first))
    end
  end

  def edit; end

  def update
    spree_current_user.update_attributes(cabinet_params)
    spree_current_user.create_or_update_address(addresses_params)

    render partial: 'user_info'
  end

  def avatar_upload
    if params[:image].present? && spree_current_user.update_attributes(avatar: params[:image])
      render partial: 'user_info'
    else
      head :unprocessable_entity
    end
  end

  private

  def cabinet_params
    data = params.require(:user)
                 .permit(:id, :first_name, :last_name, :email, :web_site, :language, :timezone, :spree_role_ids)

    if spree_current_user.admin?
      data.delete(:spree_role_ids)
    elsif !params[:user].include? :role_selected
      data[:spree_role_ids] = Spree::Role.find_by(name: 'user', category: 'default').id
    end

    data
  end

  def addresses_params
    params
      .require(:user)
      .require(:default_address_attributes)
      .permit(:address1, :city, :zipcode, :country_id, :state_id)
  end
end
