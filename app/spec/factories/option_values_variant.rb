FactoryGirl.define do
  factory :option_values_variant, class: Spree::OptionValuesVariant do
    variant
    option_value
  end
end
