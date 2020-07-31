module Spree
  module Admin
    class NewsEntriesController < Spree::Admin::ResourceController
      include LoadableForNewsEntries

      before_action :load_not_related_news_entries, only: :edit
    end
  end
end
