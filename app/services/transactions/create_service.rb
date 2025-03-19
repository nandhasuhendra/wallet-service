module Transactions
  class CreateService < ApplicationService
    def initialize(type:, creator:, params:)
      @type    = type
      @creator = creator
      @params  = params
    end

    def call
      Transaction.transaction do
        transaction = decorator_class.new(creator: @creator, description: @params[:description])
        assign_transaction_attributes(transaction, @params)
        return handler_failure(transaction.errors) unless transaction.save!

        trigger_processor(transaction.id)
        handler_success(transaction)
      end
    end

    private

    def decorator_class
      case @type
      when :deposit
        DepositDecorator
      when :payment
        PaymentDecorator
      when :transfer
        TransferDecorator
      when :withdraw
        WithdrawDecorator
      end
    end

    def assign_transaction_attributes(transaction, params)
      transaction.source_wallet = source_wallet
      transaction.target_wallet = target_wallet if @type == :transfer
      transaction.set_amount(params[:amount])
    end

    def source_wallet
      @source_wallet ||= WalletRepository.find_by_number(@params[:source_number])
    end

    def target_wallet
      @target_wallet ||= WalletRepository.find_by_number(@params[:target_number])
    end

    def trigger_processor(transaction_id)
      ::Transactions::ProcessorTransactionWorker.perform_async(transaction_id: transaction_id, type: @type)
    end
  end
end
