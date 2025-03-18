module API
  module V1
    module Users
      module Transactions
        class TransferController < ApplicationController
          def create
            @transaction = ::Transactions::CreateService.call(params: transaction_params, source: current_user, type: :transfer)
            unless @transaction.success?
              render json: { errors: @transaction.errors }, status: :unprocessable_entity
              return
            end

            render :show, status: :created
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
