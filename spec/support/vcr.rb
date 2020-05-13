require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "#{::Rails.root}/spec/cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
  config.ignore_hosts 'chromedriver.storage.googleapis.com', 'selenium_chrome', 'app'
  config.configure_rspec_metadata!
  config.default_cassette_options = {
    record: :new_episodes, # 条件に当てはまるカセットがなければ追加していく
    match_requests_on: [:method, :path, :query, :body] # カセットを引き当てる条件
  }
end
