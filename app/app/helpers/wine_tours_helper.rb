module WineToursHelper
  def variants_for_select(variants)
    variants.each_with_object([]) do |variant, memo|
      memo << [
        variant.presentation,
        { data: { price: variant.price, inclusions: variant.option_values.pluck(:presentation) } },
        variant.id
      ] unless variant.hidden?
    end
  end

  def tickets_left(tour, date_time)
    left = tour.property(CFG.tours.props.maximum).to_i - tour.count_booked_on(date_time)

    tour.property(CFG.tours.props.minimum).to_i > left ? 0 : left
  end
end
