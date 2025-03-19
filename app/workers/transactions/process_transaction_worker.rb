module Transactions
  class ProcessTransactionWorker < ApplicationWorker
    sidekiq_options retry: 3, queue: 'transaction'

    def perform(transaction_id, type)
      lock_service = RedisLockService::Lock.new
      transaction = ::Transactions::ProcessorService.call(transaction_id: transaction_id, type: type, lock_service: lock_service)

      unless transaction.success?
        raise ::Transactions::ProcessorService::Error, transaction.errors
      end
    end
  end
end
