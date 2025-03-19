require "redis_lock_service/version"
require "redis_lock_service/configuration"
require "redis_lock_service/client"
require "redis_lock_service/lock"

module RedisLockService
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end
  end
end
