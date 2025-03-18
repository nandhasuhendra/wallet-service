module Transactions
  class CreateService < ApplicationService
    def initialize(params:, source:, type:)
      @params = params
      @source = source
      @type   = type
    end

    def call
      ActiveRecord::Base.transaction do
        model_class.new(@params.merge(source: @source, wallet: wallet))
      end
    end

    private

    def wallet
      @wallet ||= WalletRepository.find_by_id_and_lock(@params[:wallet_id], @source)
    end

    def model_class
      @model_class ||= case @type
      when :withdraw
        Withdraw
      when :deposit
        Deposit
      when :payment
        Payment
      end
    end
  end
end
