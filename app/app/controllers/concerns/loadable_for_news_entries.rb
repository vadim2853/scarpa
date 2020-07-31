module LoadableForNewsEntries
  extend ActiveSupport::Concern

  private

  def load_not_related_news_entries
    @not_related_news_entries = @news_entry.not_related_news_entries
  end
end
