class SimplePagesController < StoreController
  before_action :redirect_to_coming_soon, only: %w(live_streaming club)

  def index
    @slides = Spree::Slide.published
    @featured_items = Spree::FeaturedItem.order(:position)
  end

  def contacts
  end

  def winery
    @wineries = Spree::Winery.published
  end

  def live_streaming
    render 'coming_soon/simple_pages_live_streaming'
  end

  def club
    render 'simple_pages/club'
  end
end
