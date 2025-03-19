module Transactions
  class ProcessorService < ApplicationService
    REDIS_LOCK_KEY = "wallet_lock:%{wallet_id}"
    REDIS_LOCK_TTL = 60

    Error = Class.new(StandardError)
    MissingTransactionWalletError = Class.new(Error)
    MissingSourceWalletError = Class.new(Error)
    MissingTargetWalletError = Class.new(Error)

    attr_reader :lock_service

    def initialize(transaction_id:, type: nil, lock_service: RedisLockService::Lock.new)
      @transaction_id = transaction_id
      @type           = type
      @lock_service   = lock_service
    end

    def call
      raise Error, "invalid transaction type" if type.blank?
      raise MissingTransactionWalletError, "transaction not found" if transaction.blank?

      wallet_ids = [transaction.source_id, transaction.target_id].compact
      lock_keys = wallet_ids.map { |wallet_id| REDIS_LOCK_KEY % { wallet_id: wallet_id } }
      raise "could not acquire lock for transaction #{@transaction_id}" unless acquire_locks?(lock_keys)

      processor_service_class.call(transaction: transaction)
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

    def transaction
      @transaction ||= TransactionRepository.find_by_id_with_lock(@transaction_id)
    end

    def processor_service_class
      class_name = "Transactions::Processors::#{@type.to_s.camelize}Service".constantize
    end
  end
end
