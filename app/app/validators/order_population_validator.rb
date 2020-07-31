class OrderPopulationValidator
  class << self
    def validate(product, data)
      result = []

      return result if data[:date_time].blank?

      result << 'Invalid date' unless date_valid?(product, data[:date_time])
      result << 'Does not fit quantity' unless fits_quantity?(product, data[:date_time], data[:quantity].to_i)

      result
    end

    private

    def date_valid?(product, date_time)
      TourDatesService.date_options(product).include?(date_time)
    end

    def fits_quantity?(product, date_time, quantity)
      max = product.property(CFG.tours.props.maximum).to_i
      min = product.property(CFG.tours.props.minimum).to_i
      current_count = product.count_booked_on(date_time)

      quantity >= min && (current_count + quantity) <= max
    end
  end
end
