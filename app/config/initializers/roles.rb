# If you want to change ROLES hash, please, after all manipulations,
# run Rake::Task['ensure_roles_for_spree_roles']

ROLES = [
  # default roles of Spree core
  { name: 'admin', description: 'admin', category: 'default' },
  { name: 'user', description: 'customer', category: 'default' },

  # Our additionals
  { name: 'restaurant', description: 'Restaurant / cafe', category: 'business' },
  { name: 'retail', description: 'Retail spirits sales', category: 'business' },
  { name: 'hotel', description: 'Hotel', category: 'business' },
  { name: 'catering', description: 'Catering services / events organization', category: 'business' },
  { name: 'distribution', description: 'Wine distribution / wholesale', category: 'business' },
  { name: 'club', description: 'Wine club', category: 'business' }
].freeze
