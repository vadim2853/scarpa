class TourDatesService
  FORMAT = '%d/%m/%Y %H:%M'.freeze
  SEPARATOR = /\s*,\s*/

  class << self
    def date_options(tour)
      return [] unless tour_days(tour)
      return [] unless tour_times(tour)

      now = Time.zone.now
      today = Time.zone.today.italy

      (today..(today + 1.month)).each_with_object([]) do |date, memo|
        next unless tour_days(tour).include?(date.cwday)

        tour_times(tour).each do |h, m|
          time = date.beginning_of_day.change(hour: h, min: m)

          memo << time.strftime(FORMAT) if now < time
        end
      end
    end

    private

    def tour_days(tour)
      @tour_days ||= tour.property(CFG.tours.props.days)&.split(SEPARATOR)&.map(&:to_i)
    end

    def tour_times(tour)
      @tour_times ||= tour.property(CFG.tours.props.times)&.split(SEPARATOR)&.map { |t| t.split(/\s*:\s*/) }
    end
  end
end
