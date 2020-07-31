module Spree
  module Admin
    class AudiosController < Spree::Admin::ResourceController
      belongs_to 'spree/product', find_by: :slug
      before_action :ensure_audios_number, only: [:new, :create]

      private

      def location_after_destroy
        admin_product_audios_url(@product)
      end

      def location_after_save
        admin_product_audios_url(@product)
      end

      def ensure_audios_number
        if @product.audios.where.not(id: nil).size == 2
          flash[:error] = 'You can add just 2 audios to product!'
          redirect_to admin_product_audios_url(@product)
        end
      end
    end
  end
end
