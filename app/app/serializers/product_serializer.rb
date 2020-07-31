class ProductSerializer
  def self.many(relation)
    result = {}

    # TODO: ensure includes(variants: [:images]) eager loading works
    relation.select(:id, :slug).each do |product|
      result[product.id] = one(product)
    end

    result
  end

  class << self
    private

    def one(product)
      result = {
        image: product.first_image_path,
        perfectImage: product.perfect_image_path,
        price: product.price.to_f,
        path: product_path(product)
      }

      Spree::Product::FILTER_PROPS.each { |prop| result[prop] = product.send(prop) }

      result
    end

    def product_path(product)
      Rails.application.routes.url_helpers.product_path(product)
    end
  end
end
