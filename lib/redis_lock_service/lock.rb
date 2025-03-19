module RedisLockService
  class Lock
    DEFAULT_EXPIRY = 60

    def initialize(redis = RedisLockService::Client.instance.connection)
      @redis = redis
      @default_expiry = RedisLockService.configuration.default_expiry || DEFAULT_EXPIRY
    end

    def acquire_lock(key, value = "locked", ttl: nil)
      expiry_time = ttl || @default_expiry
      @redis.set(key, value, nx: true, ex: expiry_time)
    end

    def release_lock(key)
      @redis.del(key)
    end

    def locked?(key)
      @redis.exists?(key)
    end
  end
end
