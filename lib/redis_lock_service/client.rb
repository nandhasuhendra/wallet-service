require "redis"
require "singleton"

module RedisLockService
  class Client
    include Singleton

    def initialize
      config = RedisLockService.configuration || RedisLockService::Configuration.new
      @redis = Redis.new(url: config.redis_url, reconnect_attempts: config.reconnect_attempts)
    end

    def connection
      @redis
    end
  end
end
