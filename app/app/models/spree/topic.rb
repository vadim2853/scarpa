class Spree::Topic < ActiveRecord::Base
  validates :title, presence: true, length: { in: 2..255 }

  has_attached_file :image, styles: { medium: '820x640>', icon: '120>' }

  validates_attachment :image,
                       presence: true,
                       content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png'] },
                       file_name: { matches: [/jpe?g\Z/, /png\Z/] },
                       size: { in: 0..10.megabytes }

  acts_as_list

  belongs_to :product
end
