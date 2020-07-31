class AddTitleToSpreeNewsEntries < ActiveRecord::Migration
  def change
    add_column :spree_news_entries, :title, :string
  end
end
