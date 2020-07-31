class Spree::FeaturedItem < ActiveRecord::Base
  enum item_size: [:small, :middle, :big]
  enum display_mode: [:link_to_product, :external_link, :video]

  belongs_to :spree_product, class_name: 'Spree::Product'
  has_attached_file :image, styles: { small: '560>', icon: '120>' }

  validates :item_title, :position, presence: true
  validates :item_size, inclusion: { in: item_sizes }
  validates :display_mode, inclusion: { in: display_modes }
  validates_attachment_content_type :image, content_type: %w(image/jpeg image/jpg image/png)

  def image_url
    if spree_product.present?
      spree_product.images.find_by(is_perfect_match: false).try(:attachment).try(:url)
    else
      image.url
    end
  end
end
