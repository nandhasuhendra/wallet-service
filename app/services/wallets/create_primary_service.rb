module Wallets
  class CreatePrimaryService < ApplicationService
    attr_reader :owner

    def initialize(owner:)
      @owner = owner
    end

    def call
      WalletRepository.create_default_wallet(owner)
    end
  end
end
