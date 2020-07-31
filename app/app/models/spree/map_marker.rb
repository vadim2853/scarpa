class Spree::MapMarker < ActiveRecord::Base
  enum status: [:draft, :published]
  enum marker_type: [:m_restaurant, :m_store, :m_club, :m_office]
  enum dependency: [:google, :own]

  has_attached_file :image, styles: { medium: '640>', icon: '120>' }

  validates :status, inclusion: { in: statuses }
  validates :marker_type, inclusion: { in: marker_types }
  validates :dependency, inclusion: { in: dependencies }
  validates :name, :address, :description, :work_time, :rating, presence: true, if: :own?
  validate :coordinates

  validates_attachment :image,
                       presence: true, if: :own?,
                       content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png'] },
                       file_name: { matches: [/jpe?g\Z/, /png\Z/] },
                       size: { in: 0..10.megabytes }

  class << self
    def nearest(lat, lng, filter)
      return [] if lat.blank? || lng.blank?

      select(:id, :place_id, :lat, :lng, :marker_type, :address, :review_link)
        .where(
          %(
            ST_DWithin((
              SELECT ST_SetSRID(ST_Point(lat, lng), 4326)::geography
              FROM #{Spree::MapMarker.table_name}
              WHERE status = #{Spree::MapMarker.statuses[:published]} AND marker_type IN (:filter)
              ORDER BY
                ST_Distance(
                  ST_SetSRID(ST_Point(lat,lng),4326)::geography,
                  ST_SetSRID(ST_Point(:lat,:lng),4326)::geography
                )
              LIMIT 1
            ), ST_SetSRID(ST_Point(lat,lng),4326)::geography, :distance) AND marker_type IN (:filter)
          ),
          lat: lat,
          lng: lng,
          distance: 2000,
          filter: filter.present? ? filter.map { |f| marker_types[f.to_sym] } : marker_types[:m_office]
        ).order(%(
          ST_Distance(
            ST_SetSRID(ST_Point(lat, lng), 4326)::geography,
            ST_SetSRID(ST_Point(#{sanitize_sql(lat)}, #{sanitize_sql(lng)}), 4326)::geography
          )
        )).published
    end

    def places_within_polygon(polygon, filter = nil)
      condition = if filter.present?
                    [
                      'ST_Intersects(ST_GeomFromText(:polygon), ST_Point(lat, lng)) AND marker_type IN (:filter)',
                      polygon: "POLYGON((#{polygon}))",
                      filter: filter.map { |f| marker_types[f.to_sym] }
                    ]
                  else
                    ['ST_Intersects(ST_GeomFromText(?), ST_Point(lat, lng))', "POLYGON((#{polygon}))"]
                  end

      select(:id, :place_id, :lat, :lng, :marker_type, :address, :review_link).where(condition).published
    end

    def autocomplete(query)
      return [] if query.blank?

      request(URI('https://maps.googleapis.com/maps/api/place/textsearch/json'), query: query)
    end

    def address(query)
      return [] if query.blank?

      request(URI('https://maps.googleapis.com/maps/api/geocode/json'), address: query)
    end

    def place_details(marker)
      return [] if marker.place_id.blank?

      place = request(URI('https://maps.googleapis.com/maps/api/place/details/json'), placeid: marker.place_id)
      to_map_marker(place['result'], marker) if place['result'].present?
    end

    private

    def request(uri, params, get_location = false)
      uri.query = URI.encode_www_form params.merge(key: Rails.application.secrets.googleKey)
      response = Net::HTTP.get_response uri

      output = []
      output = JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess) && response.body.present?
      output = response['location'] if get_location

      output
    end

    def to_map_marker(place, db_marker)
      marker = Spree::MapMarker.new

      marker.name = place['name']
      marker.image_file_name = place_photo(place['photos'])
      marker.description = place['international_phone_number']
      marker.rating = place['rating'].present? ? place['rating'].round : 5
      marker.address = place['formatted_address']
      marker.work_time = formatting_work_time(place['opening_hours']) if place['opening_hours'].present?
      marker.marker_type = db_marker.marker_type
      marker.review_link = db_marker.review_link

      marker.as_json_details
    end

    def formatting_work_time(opening_hours)
      opening_hours['weekday_text'].map { |day| "<p>#{day}</p>" }.join
    end

    def place_photo(photos)
      return if photos.blank?

      request(
        URI('https://maps.googleapis.com/maps/api/place/photo'),
        { maxwidth: 640, maxheight: 450, photoreference: photos.first['photo_reference'] },
        true
      ) if photos.first['photo_reference'].present?
    end
  end

  def coordinates
    return if lat.present? && lng.present?

    if google?
      errors.add :base, 'Please, type name of place into special field and select variant from dropdown!'
    else
      errors.add :base, 'Please, click on the map area for setting marker coordinates!'
    end
  end

  def as_json_details
    {
      name: name,
      image: image_url,
      description: description,
      rating: rating,
      address: address,
      work_time: work_time,
      marker_type: marker_type,
      review_link: review_link
    }
  end

  private

  def image_url
    image = own? ? image(:medium) : image_file_name

    if image.blank?
      image_name = case marker_type
                   when 'm_restaurant'
                     'restaurant.jpg'
                   when 'm_store'
                     'shop.jpg'
                   when 'm_office'
                     'vigna_alt_01.jpg'
                   else
                     'scarpa_house.jpg'
                   end

      image = ActionController::Base.helpers.asset_path(image_name)
    end
    image
  end
end
