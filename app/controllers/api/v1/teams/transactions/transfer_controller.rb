module API
  module V1
    module Teams
      module Transactions
        class TransferController < ApplicationController
          include TeamConcern

          def create
            @transaction = ::Transactions::CreateService.call(params: transaction_params, source: current_team, type: :transfer)
            unless @transaction.success?
              render json: { errors: @transaction.errors }, status: :unprocessable_entity
              return
            end

            render :show, status: :created
          end

          private

          def transaction_params
            params.require(:transaction).permit(:target, :amount, :description)
          end
        end
      end
    end
  end
end
