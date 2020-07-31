module Spree
  ProductProperty.class_eval do
    enum type_of_value: [:text, :icon]

    def property_group
      property.group if property
    end

    def property_group=(name)
      @property_group = name
    end

    def property_name=(name)
      return false if name.blank? || @property_group.blank?

      self.property = Property.find_by(name: name, group: Spree::Property.groups[@property_group.to_sym]) ||
                      Property.create(name: name, group: @property_group, presentation: name)
    end
  end
end
