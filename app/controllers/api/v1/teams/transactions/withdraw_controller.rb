module API
  module V1
    module Teams
      module Transactions
        class WithdrawController < ApplicationController
          include TeamConcern

          def create
            @transaction = ::Transactions::CreateService.call(params: transaction_params, source: current_team, type: :withdraw)
            unless @transaction.success?
              render json: { errors: @transaction.errors }, status: :unprocessable_entity
              return
            end

            render :show, status: :created
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
