module Transactions
  class CreateTransactionWorker < ApplicationWorker
    sidekiq_options retry: 3, queue: 'transaction'

    def perform(source, type, params)
      transaction = ::Transactions::CreateService.call(params: params, source: source, type: type)
      unless transaction.success?
        raise ::Transactions::CreateService::Error, transaction.errors
      end
    end
  end
end
