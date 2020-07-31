module Spree
  module Admin
    GeneralSettingsController.class_eval do
      before_action :update_currency_settings, only: :update
      before_action :update_display_coming_soon, only: :update

      def edit
        Deface::Override.new(
          virtual_path: 'spree/admin/general_settings/edit',
          name: 'currency_settings',
          disabled: true
        )
      end

      def update
        current_store.update_attributes store_params

        flash[:success] = Spree.t(:successfully_updated, resource: Spree.t(:general_settings))
        redirect_to edit_admin_general_settings_path
      end

      private

      def update_currency_settings
        params.each do |name, value|
          next unless Spree::Config.has_preference? name
          if name == 'supported_currencies'
            value = value.map { |curr| ::Money::Currency.find(curr.strip).try(:iso_code) }
                         .concat([Spree::Config[:currency]]).uniq.compact.join(',')
          end
          Spree::Config[name] = value
        end
      end

      def update_display_coming_soon
        Spree::Config.display_coming_soon = params[:display_coming_soon] == '1' ? true : false
      end
    end
  end
end
