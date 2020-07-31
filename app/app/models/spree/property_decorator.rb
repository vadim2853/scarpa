module Spree
  Property.class_eval do
    enum group: [
      :other,
      :dominant_flavours,
      :perfect_temperature,
      :wine_profile,
      :perfect_glass,
      :wine_aeration,
      :technical_data
    ]

    validates :group, presence: true, inclusion: { in: groups }
  end
end
