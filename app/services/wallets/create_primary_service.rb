module Wallets
  class CreatePrimaryService < ApplicationService
    attr_reader :owner

    def initialize(owner:)
      @owner = owner
    end

    def call
      Wallet.create!(name: ::Wallet::DEFAULT_WALLET_NAME, owner: owner, balance: 0, primary: true)
    end
  end
end
