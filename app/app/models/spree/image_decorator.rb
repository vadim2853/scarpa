module Spree
  Image.class_eval do
    belongs_to :variant, foreign_key: 'viewable_id', class_name: 'Spree::Variant'

    has_attached_file :attachment,
                      styles: {
                        mini: '48x48>',
                        small: '105x130>',
                        product: '300x370>',
                        poster: '1000x500>',
                        large: '215x700>'
                      },
                      default_style: :product,
                      default_url: 'noimage/:style.png',
                      url: '/spree/products/:id/:style/:basename.:extension',
                      path: ':rails_root/public/spree/products/:id/:style/:basename.:extension',
                      convert_options: { all: '-strip -auto-orient -colorspace sRGB' }

    before_save :ensure_perfect_match_flag

    private

    def ensure_perfect_match_flag
      variant.images.where.not(id: id).update_all(is_perfect_match: false) if is_perfect_match
    end
  end
end
