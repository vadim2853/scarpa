module Spree
  module Admin
    class RelatedNewsEntriesController < ApplicationController
      include LoadableForNewsEntries

      before_action :load_news_entry

      def create
        @related_news_entry = NewsEntryRelation.new(related_id: news_entry_id, inverse_related_id: related_id)
        if @related_news_entry.save
          @new_related_news_entry = Spree::NewsEntry.find(related_id)
          load_not_related_news_entries
        end
        respond_to { |format| format.js }
      end

      def destroy
        NewsEntryRelation.delete_relations(news_entry_id, related_id)
        @deleted_related_news_entry_id = related_id

        load_not_related_news_entries
        respond_to { |format| format.js }
      end

      private

      def load_news_entry
        @news_entry = Spree::NewsEntry.find(news_entry_id)
      end

      def related_id
        params.require(:related_id)
      end

      def news_entry_id
        params.require(:id)
      end
    end
  end
end
