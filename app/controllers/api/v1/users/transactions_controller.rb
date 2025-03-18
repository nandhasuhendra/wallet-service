module API
  module V1
    module Users
      class TransactionsController < ApplicationController
        def index
          @transactions = TransactionRepository.find_by_wallet_id(params[:wallet_id])
        end

        def create
          @transaction = ::Transactions::CreateService.call(params: transaction_params, source: current_user)
          unless @transaction.success?
            render json: { errors: @transaction.errors }, status: :unprocessable_entity
            return
          end

          render :show, status: :created
        end

        def show
          @transaction = Transaction.find(params[:id])
        end

        def update
          @transaction = ::Transactions::UpdateService.call(id: params[:id], description: transaction_params[:description], source: current_user)
          unless @transaction.success?
            render json: { errors: @transaction.errors }, status: :unprocessable_entity
            return
          end

          render :show, status: :ok
        end

        private

        def transaction_params
          params.require(:transaction).permit(:target, :amount, :description)
        end
      end
    end
  end
end
