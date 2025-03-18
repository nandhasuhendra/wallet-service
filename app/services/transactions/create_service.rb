module Transactions
  class CreateService < ApplicationService
    def initialize(params:, source:, type:)
      @source = source
      @params = params
      @type   = type
    end

    def call
      handler_success(transaction)
    end

    private
  end
end
