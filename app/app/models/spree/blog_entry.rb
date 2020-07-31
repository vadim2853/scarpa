class Spree::BlogEntry < ActiveRecord::Base
  extend ByMonthable

  belongs_to :user, class_name: Spree::UserClassHandle.new

  validates :title, :preview_text, :full_text, :user, :posted_on, presence: true

  acts_as_commentable
end
