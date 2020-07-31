class CalculatorLoadingInteraction
  def initialize(*)
    @events = {}
    @months = {}
    @products = {}
    @backgrounds = {}
    @products_ids = []

    iterate_events
    iterate_months
    iterate_products
    iterate_backgrounds
  end

  def as_json(*)
    {
      events: @events,
      months: @months,
      dayIcon: image_path('party_range_sun.png'),
      products: @products,
      nightIcon: image_path('party_range_moon.png'),
      backgrounds: @backgrounds
    }
  end

  private

  def iterate_events
    Spree::Calculator::Event
      .joins(:backgrounds)
      .includes(:backgrounds, :products)
      .each do |e|
        @products_ids << e.products.map(&:id)

        @events[e.id] = {
          name: e.name,
          redRate: e.red_rate,
          products: @products_ids.last,
          whiteRate: e.white_rate,
          backgrounds: e.backgrounds.map(&:id)
        }
      end
  end

  def iterate_months
    Spree::Calculator::Month.includes(:products).each do |m|
      @products_ids << m.products.map(&:id)

      id = month_number(m.name)

      @months[id] = {
        icon: month_icon(id),
        name: m.name,
        rate: m.rate,
        products: @products_ids.last
      }
    end
  end

  def iterate_backgrounds
    Spree::Calculator::Background.all.each do |b|
      @backgrounds[b.id] = {
        guests: b.guests,
        default: b.is_default,
        eventId: b.calculator_event_id,
        monthId: b.calculator_month_id,
        imagePath: b.image&.url
      }
    end
  end

  def iterate_products
    Spree::Product.includes(:product_properties).where(id: @products_ids.flatten).each do |p|
      @products[p.id] = {
        path: Rails.application.routes.url_helpers.product_path(p),
        name: p.name,
        image: p.first_image_path,
        color: p.color.first&.downcase
      }
    end
  end

  def image_path(name)
    ActionController::Base.helpers.image_path(name)
  end

  def month_number(name)
    month_name = name.titleize

    Date::MONTHNAMES.index(month_name) || Date::ABBR_MONTHNAMES.index(month_name)
  end

  def month_icon(id)
    case id
    when 3..5 then image_path('spring.svg')
    when 6..8 then image_path('summer.svg')
    when 9..11 then image_path('autumn.svg')
    else image_path('winter.svg')
    end
  end
end
