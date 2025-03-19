module Transactions
  module Processors
    class TransferService < ApplicationService
      def initialize(transaction:)
        @transaction = transaction
      end

      def call
        raise ::Transactions::Processors::ErrorSourceWalletNotFound if source_wallet.nil?

        ActiveRecord::Base.transaction do
          source_wallet.decrement!(:balance, @transaction.debit)
          target_wallet.increment!(:balance, @transaction.credit)
          @transaction.update!(status: :completed)
        end
      end
    end
  end
end
