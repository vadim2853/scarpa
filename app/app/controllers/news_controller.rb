class NewsController < StoreController
  def index
    @news = Spree::NewsEntry.by_month(params[:by_month])
                            .order(posted_on: :desc)
                            .published
                            .page(params[:page])
  end

  def show
    @news_entry = Spree::NewsEntry.find params[:id]
    @news_entry.increment(:view_count).save
  end
end
