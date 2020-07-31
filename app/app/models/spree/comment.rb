class Spree::Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment

  COMMENT_TYPE = 'Spree::Comment'.freeze

  belongs_to :commentable, polymorphic: true
  belongs_to :user, class_name: Spree::UserClassHandle.new

  default_scope -> { order(created_at: :desc) }

  validates :comment, :commentable, :user, :root_commentable_id, presence: true

  acts_as_commentable
end
