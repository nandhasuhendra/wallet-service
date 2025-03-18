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
        end

        private

        def current_team
          @current_team ||= current_user.teams.find(params[:team_id])
        end
      end
    end
  end
end
