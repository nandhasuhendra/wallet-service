module API
  module V1
    module Teams
      module Transactions
        class TransferController < ApplicationController
          include TeamConcern

          def create
            ::Transactions::CreateTransactionWorker.perform_async(current_team, :transfer, transaction_params)
            head :created
          end

          private

          def transaction_params
            params.require(:transaction).permit(:target_id, :target_type, :amount, :description)
          end
        end
      end
    end
  end
end
