module API
  module V1
    module Users
      module Transactions
        class DepositController < ApplicationController
          def create
            ::Transactions::CreateTransactionWorker.perform_async(current_user, :deposit, transaction_params)
            head :created
          end

          private

          def transaction_params
            params.require(:transaction).permit(:amount, :description)
          end
        end
      end
    end
  end
end
