class BlogsController < StoreController
  before_action :recent_blogs, only: [:index, :show]

  def index
    @blog_entries = Spree::BlogEntry.by_month(params[:by_month])
                                    .order(posted_on: :desc)
                                    .page(params[:page])
  end

  def show
    @blog_entry = Spree::BlogEntry.find params[:id]
    @blog_entry.increment(:view_count).save
  end

  private

  def recent_blogs
    @recent_blogs = Spree::BlogEntry.order(posted_on: :desc).limit(5)
  end
end
