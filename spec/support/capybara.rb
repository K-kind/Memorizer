require 'capybara/rspec'

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium, using: :headless_chrome, options: {
      browser: :remote,
      url: ENV.fetch('SELENIUM_DRIVER_URL'),
      desired_capabilities: :chrome
    }
    Capybara.server_host = 'app'
    Capybara.app_host = 'http://app'
  end
end
