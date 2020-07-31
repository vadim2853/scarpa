module Spree
  module Admin
    ProductsController.class_eval do
      include LoadableForProducts

      before_action :load_not_related_products, :load_wine_glasses, only: :edit

      private

      def location_after_save
        if updating_variant_property_rules?
          url_params = {}
          url_params[:ovi] = []
          params[:product][:variant_property_rules_attributes].each do |_index, param_attrs|
            url_params[:ovi] += param_attrs[:option_value_ids]
          end
          spree.admin_product_product_properties_url(@product, url_params)
        elsif updating_properties?
          spree.admin_product_product_properties_url(@product)
        else
          spree.edit_admin_product_url(@product)
        end
      end

      def updating_properties?
        params[:product][:product_properties_attributes].present?
      end
    end
  end
end
