FactoryGirl.define do
  factory :map_marker, class: Spree::MapMarker do |s|
    s.place_id 'ChIJJfWwQuCFh0cRZmuFgG-z-Sg'
    s.name 'Antica Casa Vinicola Scarpa S.R.L.'
    s.address 'Via Montegrappa, 6, Nizza Monferrato AT, Italy'
    s.lat 44.7712037
    s.lng 8.350949
    s.marker_type Spree::MapMarker.marker_types[:m_store]
    s.status Spree::MapMarker.statuses[:published]
    s.created_at Time.zone.today
    s.updated_at Time.zone.today
  end
end
