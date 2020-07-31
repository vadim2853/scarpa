ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'rspec/given'
require 'ffaker'

ActiveRecord::Migration.maintain_test_schema!

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include HelperMethods
  config.include Devise::TestHelpers, type: :controller
  config.include ShowMeTheCookies, type: :feature

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before(:all) do
    Spree::Config.display_coming_soon = false
  end

  config.after(type: :feature) do
    delete_cookie('is_adult')
  end

  config.after(:all) do
    FileUtils.rm_rf(Dir["#{Rails.root}/public/test_uploads"])
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
