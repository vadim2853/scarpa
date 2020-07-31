class CatalogueService
  def self.process(products)
    options = Spree::Product::FILTER_PROPS.map { |prop| [prop, map_uniq_values(products, prop)] }.to_h

    prices = map_uniq_values(products, :price)

    {
      maxPrice: prices.last,
      minPrice: prices.first,
      products: products,
      options: options
    }
  end

  class << self
    private

    # rubocop:disable Metrics/PerceivedComplexity
    def map_uniq_values(products, field)
      vals = if products.is_a?(Array)
               products
             elsif products.is_a?(Hash)
               products.values
             end.map { |p| p[field] }

      if vals.first.is_a?(Array) || vals.first.is_a?(Float) # for simple lists and prices
        vals.flatten.uniq.select(&:present?).sort
      elsif vals.first.is_a?(Hash) # for grouped lists
        prepare_categorized_properties(vals)
      end
    end
    # rubocop:enable Metrics/PerceivedComplexity

    def prepare_categorized_properties(products_values)
      props = {}
      products_values.each do |products_value|
        next if products_value.blank?
        products_value.keys.each do |key|
          props[key] = props[key].present? ? (props[key] | products_value[key]) : products_value[key]
        end
      end

      output = [{ text: Spree.t(:cuisines), children: props.delete('Cuisine') }]
      props.each do |prop|
        output << { text: prop.first, children: prop.second }
      end

      output
    end
  end
end
