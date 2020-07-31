module Spree
  AppConfiguration.class_eval do
    preference :display_coming_soon, :boolean, default: true
  end
end
