module Wallets
  class CreatePrimaryService < ApplicationService
    attr_reader :owner

    def initialize(owner:)
      @owner = owner
    end

    def call
      Wallet.create!(owner: owner, balance: 0, primary: true)
    end
  end
end
