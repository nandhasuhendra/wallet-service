module Wallets
  class CreateAdditionalWalletService < ApplicationService
    attr_reader :owner

    def initialize(owner:, name:, balance: 0.0)
      @owner   = owner
      @name    = name
      @balance = balance
    end

    def call
      wallet = WalletRepository.create_wallet(owner, name, balance)
      return handler_failure(wallet.errors) unless wallet.persisted?

      handler_success(wallet)
    end
  end
end
