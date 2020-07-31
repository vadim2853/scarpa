FactoryGirl.define do
  factory :property, class: Spree::Property do
    name 'baseball_cap_color'
    presentation 'cap color'
    group Spree::Property.groups.values.first
  end
end
