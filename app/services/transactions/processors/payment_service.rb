module Transactions
  module Processors
    class PaymentService < ApplicationService
      def initialize(source_transaction:, target_transaction:)
        @source_transaction = source_transaction
        @target_transaction = target_transaction
      end

      def call
      end
    end
  end
end
