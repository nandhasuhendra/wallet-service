module Transactions
  module Processors
    class DepositService < ApplicationService
      include ::Transactions::Processors::Helper

      def initialize(transaction:)
        @transaction = transaction
      end

      def call
        raise ::Transactions::Processors::ErrorSourceWalletNotFound if source_wallet.nil?

        ActiveRecord::Base.transaction do
          source_wallet.increment!(:balance, @transaction.credit)
          @transaction.update!(status: :completed)
        end
      end
    end
  end
end
