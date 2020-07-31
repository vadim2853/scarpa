require 'active_record'

namespace :scarpa do
  task add_default_calculator_events: :environment do
    [
      'Wedding',
      'Picnic',
      'Birthday celebration',
      'Holiday',
      'Sport event',
      'Dinner party'
    ].each { |name| Spree::Calculator::Event.find_or_create_by(name: name, red_rate: 1, white_rate: 1) }
  end
end
