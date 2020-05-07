require 'capybara/rspec'

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  chrome_url = ENV.fetch('SELENIUM_DRIVER_URL')

  config.before(:each, type: :system, js: true) do
    driven_by :selenium, using: :headless_chrome, options: {
      browser: :remote,
      url: chrome_url,
      desired_capabilities: :chrome
    }
    # docker-composeではhostがapp、CI時はlocalhostのため設定不要
    if chrome_url == 'http://selenium_chrome:4444/wd/hub'
      Capybara.server_host = 'app'
      Capybara.app_host = 'http://app.local/'
    end
    Capybara.default_max_wait_time = 5
  end
end
