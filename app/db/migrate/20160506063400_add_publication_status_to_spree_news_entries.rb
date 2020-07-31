class AddPublicationStatusToSpreeNewsEntries < ActiveRecord::Migration
  def change
    add_column :spree_news_entries, :status, :integer, default: 0
  end
end
