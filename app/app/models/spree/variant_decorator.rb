module Spree
  Variant.class_eval do
    def date_option
      option_values.joins(:option_type).find_by(spree_option_types: { name: CFG.tours.options.time })&.name
    end
  end
end
