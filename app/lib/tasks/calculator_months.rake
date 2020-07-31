require 'active_record'

namespace :scarpa do
  task add_months_to_spree_calculator_months: :environment do
    (1..12).each { |m| Spree::Calculator::Month.find_or_create_by(name: Date::MONTHNAMES[m], rate: 1) }
  end
end
