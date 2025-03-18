module API
  module V1
    module Teams
      module Transactions
        class WithdrawController < ApplicationController
          include TeamConcern

          def create
            ::Transactions::CreateTransactionWorker.perform_async(current_team, :withdraw, transaction_params)
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
