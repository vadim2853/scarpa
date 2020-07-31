# rubocop:disable all
module Spree
  Product.class_eval do
    const_set(:FILTER_PROPS, %i(color age food mood music time_of_the_day season location taste))

    has_and_belongs_to_many :related, class_name: 'Product', join_table: 'product_relations',
                                      foreign_key: :related_id, association_foreign_key: :inverse_related_id
    has_and_belongs_to_many :inverse_related, class_name: 'Product', join_table: 'product_relations',
                                              foreign_key: :inverse_related_id, association_foreign_key: :related_id
    has_many :topics, -> { order(position: :asc) }
    has_many :audios, -> { order(position: :asc) }
    has_many :product_descriptions, -> { order(position: :asc) }
    has_one :featured_item, class_name: 'FeaturedItem', foreign_key: 'spree_product_id'

    belongs_to :wine_glass, class_name: 'Product', foreign_key: 'wine_glass_id'

    scope :by_taxon, -> (name) { joins(:taxons).where(spree_taxons: { name: name }) }

    acts_as_commentable

    def self.find_by_variant(variant_id)
      joins(:variants).find_by(spree_variants: { id: variant_id })
    end

    def count_booked_on(date_time)
      Spree::LineItem
        .joins(variant: [:option_values, :product])
        .where(spree_option_values: { name: date_time }, spree_products: { id: id })
        .sum(:quantity)
    end

    def wine_glass?
      taxons.where(name: CFG.taxons.wine_glass.title).any?
    end

    def related_products
      Spree::Product.from(
        Spree::Product.connection.unprepared_statement do
          "((#{related.to_sql}) UNION (#{inverse_related.to_sql})) AS #{Spree::Product.table_name}"
        end
      )
    end

    def ordered_related_products
      related_products.limit(3).order('RANDOM()')
    end

    def not_related_products
      Spree::Product.where.not(id: [related_products.select(:id), id].flatten).by_taxon(CFG.taxons.wine.title)
    end

    def first_image_path
      images.find_by(is_perfect_match: false).try(:attachment, :large)
    end

    def first_poster_path
      images.first&.attachment(:poster)
    end

    def perfect_image_path
      images.reorder(is_perfect_match: :desc).first.try(:attachment, :large) || first_image_path
    end

    const_get(:FILTER_PROPS).each do |prop_name|
      define_method(prop_name) do
        hash_result  = {}
        array_result = []

        product_properties
          .joins(:property)
          .where(spree_properties: { name: prop_name.to_s.humanize })
          .find_each do |prop|
            if prop[:category].present? && prop[:value].present?
              (hash_result[prop[:category]] ||= []) << prop[:value]
            elsif prop[:value].present?
              array_result << prop[:value]
            end
          end

        return hash_result.present? ? hash_result : array_result
      end
    end

    Spree::ProductDescription.kinds.each do |kind, value|
      define_method("#{kind}_description") do
        product_descriptions.find_by(kind: value)&.body
      end
    end
  end
end
