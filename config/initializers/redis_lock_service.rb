RedisLockService.configure do |config|
  config.redis_url = ENV["REDIS_URL"]
  config.default_expiry = 120
  config.reconnect_attempts = 5
end
