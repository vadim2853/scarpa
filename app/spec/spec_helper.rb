require 'paperclip/matchers'
require 'spree/testing_support/authorization_helpers'
require 'rspec/retry'

RSpec.configure do |config|
  config.include Paperclip::Shoulda::Matchers

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random
  config.verbose_retry = true
  config.display_try_failure_messages = true

  Kernel.srand config.seed
end
