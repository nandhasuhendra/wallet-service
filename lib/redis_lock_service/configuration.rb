module RedisLockService
  class Configuration
    attr_accessor :redis_url, :default_expiry, :reconnect_attempts

    def initialize
      @redis_url = ENV.fetch("REDIS_URL", "redis://localhost:6379/0")
      @default_expiry = 60
      @reconnect_attempts = 3
    end
  end
end
