module LoadableForCalculator
  extend ActiveSupport::Concern

  def permitted_resource_params
    obj_name = "calculator_#{controller_name.singularize}"
    params[obj_name].present? ? params.require(obj_name).permit! : ActionController::Parameters.new
  end

  def model_class
    "Spree::Calculator::#{controller_name.classify}".constantize
  end

  private

  def load_not_month_products
    @not_month_products = @month.not_month_products
  end

  def load_not_event_products
    @not_event_products = @event.not_event_products
  end
end
