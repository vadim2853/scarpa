module Spree
  Address.class_eval do
    def readonly?
      false
    end

    def self.build_default
      new(country: (Spree::Country.find_by(name: 'Italy') || Spree::Country.default))
    end
  end
end
