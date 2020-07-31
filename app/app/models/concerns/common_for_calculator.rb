require 'active_support/concern'

module CommonForCalculator
  extend ActiveSupport::Concern

  included do
    default_scope { order(:id) }

    define_method "not_#{model_name.element}_products" do
      Spree::Product.where.not(id: [products.select(:id), id].flatten).by_taxon(CFG.taxons.wine.title)
    end
  end
end
