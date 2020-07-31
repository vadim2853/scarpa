require 'active_record'

namespace :scarpa do
  task ensure_default_tax_category_for_products: :environment do
    Spree::Product.update_all(tax_category_id: Spree::TaxCategory.find_by(is_default: true).id)
  end
end
