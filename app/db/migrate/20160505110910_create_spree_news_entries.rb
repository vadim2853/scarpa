class CreateSpreeNewsEntries < ActiveRecord::Migration
  def change
    create_table :spree_news_entries do |t|
      t.text :preview_text
      t.text :full_text
      t.integer :view_count, default: 0
      t.date :posted_on

      t.timestamps null: false
    end
  end
end
