class Spree::NewsEntry < ActiveRecord::Base
  extend ByMonthable

  enum status: [:draft, :published]

  paginates_per 10

  validates :title, :preview_text, :full_text, :posted_on, presence: true

  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :related, class_name: 'NewsEntry', join_table: 'spree_news_entry_relations',
                                    foreign_key: :related_id, association_foreign_key: :inverse_related_id
  has_and_belongs_to_many :inverse_related, class_name: 'NewsEntry', join_table: 'spree_news_entry_relations',
                                            foreign_key: :inverse_related_id, association_foreign_key: :related_id
  # rubocop:enable Rails/HasAndBelongsToMany

  scope :top_news, -> { select(:id, :title, :posted_on).order(posted_on: :desc).limit(5).published }

  def related_news_entries
    Spree::NewsEntry.from(
      Spree::NewsEntry.connection.unprepared_statement do
        "((#{related.to_sql}) UNION (#{inverse_related.to_sql})) AS #{Spree::NewsEntry.table_name}"
      end
    )
  end

  def random_related_news_entries
    related_news_entries.limit(2).order('RANDOM()')
  end

  def not_related_news_entries
    Spree::NewsEntry.where.not id: [related_news_entries.select(:id), id].flatten
  end
end
