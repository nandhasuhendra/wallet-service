module API
  module V1
    module Teams
      class TransactionsController < ApplicationController
        def index
          @transactions = TransactionRepository.find_by_wallet_id(params[:wallet_id])
        end

        def create
        end

        def show
          @transaction = Transaction.find(params[:id])
        end

        def update
          @transaction = ::Transactions::UpdateService.call(id: params[:id], description: transaction_params[:description], source: current_team)
          unless @transaction.success?
            render json: { errors: @transaction.errors }, status: :unprocessable_entity
            return
          end

          render :show, status: :ok
        end

        private

        def transaction_params
          params.require(:transaction).permit(:target, :amount, :category, :description)
        end

        def current_team
          @current_team ||= current_user.teams.find(params[:team_id])
        end
      end
    end
  end
end
