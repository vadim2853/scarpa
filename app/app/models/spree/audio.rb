class Spree::Audio < ActiveRecord::Base
  validates :title, :title_it, length: { in: 2..255 }
  validates :description, :description_it, presence: true
  validate :ensure_audios_number

  has_attached_file :image, styles: { medium: '410>', icon: '120>' }

  validates_attachment :image,
                       presence: true,
                       content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png'] },
                       file_name: { matches: [/jpe?g\Z/, /png\Z/] },
                       size: { in: 0..10.megabytes }

  acts_as_list

  belongs_to :product

  private

  def ensure_audios_number
    errors.add(:permissible_number, 'of entries - only two!') if product && new_record? && product.audios.size == 2
  end
end
