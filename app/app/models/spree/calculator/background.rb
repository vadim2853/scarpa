class Spree::Calculator::Background < ActiveRecord::Base
  default_scope { order(:calculator_event_id) }

  belongs_to :event, foreign_key: 'calculator_event_id'
  belongs_to :month, foreign_key: 'calculator_month_id'

  validates :event, :month, :guests, presence: true

  has_attached_file :image, styles: { medium: '1280>', small: '560>', icon: '120>' }

  validates_attachment :image,
                       presence: true,
                       content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png'] },
                       file_name: { matches: [/jpe?g\Z/, /png\Z/] },
                       size: { in: 0..10.megabytes }

  before_save :provide_default_for_event_type

  private

  def provide_default_for_event_type
    if is_default
      self.class.where('calculator_event_id = ? AND id <> ?', calculator_event_id, id).update_all(is_default: false)
    end
  end
end
