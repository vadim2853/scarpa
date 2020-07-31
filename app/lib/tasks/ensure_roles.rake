require 'active_record'

namespace :db do
  task ensure_roles_for_spree_roles: :environment do
    ROLES.each do |item|
      role = Spree::Role.where(name: item[:name], category: item[:category]).take || Spree::Role.new
      role.name = item[:name]
      role.description = item[:description]
      role.category = item[:category]
      role.save
    end
  end

  task turn_back_default_spree_roles: :environment do
    Spree::Role.find_each { |role| role.destroy unless %w(admin user).include?(role.name) }
  end
end
