module Transactions
  class ProcessorService < ApplicationService
    REDIS_LOCK_KEY = "wallet_lock:%{wallet_id}"
    REDIS_LOCK_TTL = 60

    Error = Class.new(StandardError)
    MissingSourceTransactionError = Class.new(Error)
    MissingTargetTransactionError = Class.new(Error)

    attr_reader :lock_service

    def initialize(source_transaction_id:, target_transaction_id:, type: nil, lock_service: RedisLockService::Lock.new)
      @source_transaction_id = source_transaction_id
      @target_transaction_id = target_transaction_id
      @type                  = type
      @lock_service          = lock_service
    end

    def call
      raise Error, "invalid transaction type" if type.blank?
      raise MissingSourceTransactionError if source_transaction.blank?

      wallets = [source_transaction.wallet_id, target_transaction.try(:wallet_id)].compact
      lock_keys = wallets.map { |wallet_id| REDIS_LOCK_KEY % { wallet_id: wallet_id } }
      raise "could not acquire lock for transaction #{@source_transaction_id}" unless acquire_locks?(lock_keys)

      processor_service_class.call(source_transaction: transaction, target_transaction: target_transaction)
    rescue StandardError => e
      transaction.fail!
      raise e
    ensure
      release_lock(lock_keys)
    end

    private

    def acquire_locks?(lock_keys)
      lock_keys.all? { |lock_key| lock_service.acquire_lock(lock_key) }
    end

    def release_lock(lock_keys)
      lock_keys.each { |lock_key| lock_service.release_lock(lock_key) }
    end

    def source_transaction
      @source_transaction ||= TransactionRepository.find_by_id_with_lock(@source_transaction_id)
    end

    def target_transaction
      @target_transaction ||= TransactionRepository.find_by_id_with_lock(@target_transaction_id)
    end

    def processor_service_class
      class_name = "Transactions::Processors::#{@type.to_s.camelize}Service".constantize
    end
  end
end
