require 'rspec/retry'

RSpec.configure do |config|
  config.verbose_retry = true
  config.display_try_failure_messages = true
end
