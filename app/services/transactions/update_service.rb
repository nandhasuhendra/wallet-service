module Transactions
  class UpdateService < ApplicationService
    def initialize(id:, description:, source:)
      @id = id
      @description = description
      @source = source
    end

    def call
      transaction = TransactionRepository.find_by_id_and_lock(@id)
      return handler_success(transaction) if transaction.update(description: @description)

      handler_failure(transaction.errors)
    end
  end
end
