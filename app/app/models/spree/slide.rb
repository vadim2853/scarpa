class Spree::Slide < ActiveRecord::Base
  enum status: [:draft, :published]

  validates :title, :description, presence: true
  validates :title, length: { in: 2..255 }
  validates :status, inclusion: { in: statuses }

  has_attached_file :image,
                    styles: { medium: '1024>', small: '560>', icon: '120>' }

  validates_attachment :image,
                       presence: true,
                       content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png'] },
                       file_name: { matches: [/jpe?g\Z/, /png\Z/] },
                       size: { in: 0..10.megabytes }
end
