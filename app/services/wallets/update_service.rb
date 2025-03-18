module Wallets
  class UpdateService < ApplicationService
    attr_reader :wallet, :name, :balance

    def initialize(wallet_id:, owner:, name:, balance: 0.0)
      @wallet_id  = wallet_id
      @name       = name
      @balance    = balance
    end

    def call
      wallet = WalletRepository.find_by_id_and_owner(owner)
      return handler_failure("wallet not found") unless wallet
      return handler_success(wallet) if wallet.update(name: name, balance: balance)

      handler_failure(wallet.errors)
    end
  end
end
