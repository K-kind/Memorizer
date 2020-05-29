if ENV['REDIS_URL']
  sidekiq_config = { url: "redis://#{ENV['REDIS_URL']}:6379" }

  Sidekiq.configure_server do |config|
    config.redis = sidekiq_config
  end

  Sidekiq.configure_client do |config|
    config.redis = sidekiq_config
  end
end
