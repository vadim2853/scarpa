module Spree
  User.class_eval do
    include OrderHistory

    enum language: [:english, :italian]

    has_many :grades_results

    has_attached_file :avatar,
                      convert_options: { all: '-auto-orient -quality 100' },
                      styles: { small: '80x80#', medium: '420>' },
                      default_style: :small

    validates_attachment :avatar,
                         content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png'] },
                         file_name: { matches: [/jpe?g\Z/, /png\Z/] },
                         size: { in: 0..10.megabytes }

    delegate :url, to: :avatar, prefix: true

    def full_name
      "#{first_name} #{last_name}"
    end

    def create_or_update_address(attrs)
      if default_address.present?
        default_address.update_columns(attrs)
      else
        address = Spree::Address.new(attrs)
        address.save(validate: false)

        Spree::UserAddress.create(user_id: id, address_id: address.id, default: true)
        update_columns(ship_address_id: address.id, bill_address_id: address.id)
      end
    end

    def access_to_grade?(selected_grade_id, first_grade_id)
      results = Spree::GradesResult.select(:grade_id, :percent).where(user_id: id)

      if results.present?
        last_result   = results.last
        available_ids = results.map(&:grade_id)
        available_ids << (last_result.grade_id + 1) if last_result.percent >= Spree::Grade::PASSING_SCORE

        available_ids.include?(selected_grade_id)
      else
        selected_grade_id == first_grade_id
      end
    end

    protected

    def confirmation_required?
      false
    end
  end
end
