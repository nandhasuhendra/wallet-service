module API
  module V1
    module Users
      module Transactions
        class DepositController < ApplicationController
          def create
            @transaction = ::Transactions::CreateService.call(params: transaction_params, creator: current_user, type: :deposit)
            unless @transaction.success?
              render json: { errors: @transaction.errors }, status: :unprocessable_entity
              return
            end

            render :show, status: :created
          end

          private

          def transaction_params
            params.require(:transaction).permit(:amount, :description, :source_number)
          end
        end
      end
    end
  end
end
