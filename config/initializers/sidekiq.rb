Sidekiq.configure_server do |config|
  case Rails.env
    when 'production' then
      redis_conn = proc {
        Redis.new(host: ENV['REDIS_URL'], port: 6379, db: 2)
      }
      config.redis = ConnectionPool.new(size: 27, &redis_conn)
    else
      config.redis = { url: ENV['REDIS_URL'] }
  end
end

Sidekiq.configure_client do |config|
  case Rails.env
    when 'production' then
      redis_conn = proc {
        Redis.new(host: ENV['REDIS_URL'], port: 6379, db: 2)
      }
      config.redis = ConnectionPool.new(size: 27, &redis_conn)
    else
      config.redis = { url: ENV['REDIS_URL'] }
  end
end
