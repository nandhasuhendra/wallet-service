module API
  module V1
    module Teams
      module Transactions
        class DepositController < ApplicationController
          include TeamConcern

          def create
            ::Transactions::CreateTransactionWorker.perform_async(current_team, :deposit, transaction_params)
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
