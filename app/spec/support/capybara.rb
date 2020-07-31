require 'capybara/rspec'
require 'capybara/rails'

Capybara.default_max_wait_time = 15

Capybara.register_driver :chrome do |app|
  client = Selenium::WebDriver::Remote::Http::Default.new

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    http_client: client,
    desired_capabilities: {
      'chromeOptions' => {
        'args' => %w( window-size=1280,800 )
      }
    }
  )
end

Capybara.javascript_driver = :chrome

ShowMeTheCookies.register_adapter(:chrome, ShowMeTheCookies::Selenium)

RSpec.configure do |config|
  config.include Capybara::DSL
end
