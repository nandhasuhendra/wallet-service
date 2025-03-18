module Transactions
  module Processors
    class TransferService < ApplicationService
      def initialize(source_transaction:, target_transaction:)
        @source_transaction = source_transaction
        @target_transaction = target_transaction
      end

      def call
        raise Transactions::Processors::MissingTargetTransactionError if @target_transaction.blank?
      end
    end
  end
end
