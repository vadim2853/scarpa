require 'rails_helper'

RSpec.describe Spree::Property, type: :model do
  it { should validate_presence_of :group }
  it do
    should define_enum_for(:group).with [
      :other,
      :dominant_flavours,
      :perfect_temperature,
      :wine_profile,
      :perfect_glass,
      :wine_aeration,
      :technical_data
    ]
  end
end
