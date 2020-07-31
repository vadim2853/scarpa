module Spree
  class Nomination < ActiveRecord::Base
    default_scope { order(position: :asc) }

    belongs_to :grade

    has_attached_file :icon,
                      convert_options: { all: '-auto-orient -quality 100' },
                      styles: { small: '30>', medium: '155>', large: '200>' },
                      default_style: :medium

    validates_attachment :icon,
                         content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png'] },
                         file_name: { matches: [/jpe?g\Z/, /png\Z/] },
                         size: { in: 0..10.megabytes }

    validates :grade, :title, :min, presence: true

    acts_as_list
  end
end
