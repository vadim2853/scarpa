module ProductsHelper
  # Returns the formatted price for the specified variant as a full price or
  # a difference depending on configuration
  #
  # @param variant [Spree::Variant] the variant
  # @return [Spree::Money] the price or price diff
  def variant_price(variant)
    Spree::Config[:show_variant_full_price] ? variant_full_price(variant) : variant_price_diff(variant)
  end

  # Returns the formatted price for the specified variant as a difference
  # from product price
  #
  # @param variant [Spree::Variant] the variant
  # @return [String] formatted string with label and amount
  def variant_price_diff(variant)
    variant_amount = variant.amount_in(current_currency)
    product_amount = variant.product.amount_in(current_currency)
    return if variant_amount == product_amount || product_amount.nil?
    diff   = variant.amount_in(current_currency) - product_amount
    amount = Spree::Money.new(diff.abs, currency: current_currency).to_html
    label  = diff > 0 ? :add : :subtract
    "(#{Spree.t(label)}: #{amount})".html_safe
  end

  # Returns the formatted full price for the variant, if at least one variant
  # price differs from product price.
  #
  # @param variant [Spree::Variant] the variant
  # @return [Spree::Money] the full price
  def variant_full_price(variant)
    product = variant.product
    unless product.variants.active(current_currency).all? { |v| v.price == product.price }
      Spree::Money.new(variant.price, currency: current_currency).to_html
    end
  end

  def product_price_variants
    output = []
    @product_variants_and_option_values.each do |variant|
      data = option_data_from(variant: variant)
      next if data.blank?

      option_value = data[:option_value]
      option_name  = data[:option_name]

      image_url = if option_name.include?('bottle')
                    image_path('select_product_bottle.png')
                  else
                    image_path('select_product_crate.png')
                  end

      output << [
        "PER #{Spree.t(option_name)} #{option_value.presentation}", # PER Bottle 0.75L
        { 'data-quantity' => variant.price, 'data-icon' => option_name, 'data-image-url' => image_url },
        variant.id
      ]
    end

    output
  end

  # rubocop:disable all
  def option_data_from(variant:)
    option_values = variant.option_values

    age_value = option_values.second
    if age_value.blank? && params[:age].blank? ||
       params[:age].present? && age_value.present? && age_value.name == params[:age] ||
       age_value.present? && params[:age].blank? && @ages.present? && age_value.name == @ages.first

      single_option_data_from(variant, option_values)
    end
  end
  # rubocop:enable all

  def single_option_data_from(variant, option_values = nil)
    option_value = (option_values.present? ? option_values : variant.option_values).first

    { option_value: option_value, option_name: option_value.option_type.name.downcase }
  end

  def variant_id_from(price_variants:)
    price_variants.first[2]
  end

  # Filters and truncates the given description.
  #
  # @param description_text [String] the text to filter
  # @return [String] the filtered text
  def line_item_description_text(description_text)
    if description_text.present?
      truncate(strip_tags(description_text.gsub('&nbsp;', ' ')), length: 100)
    else
      Spree.t(:product_has_no_description)
    end
  end
end
