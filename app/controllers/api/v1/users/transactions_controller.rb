module API
  module V1
    module Users
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
      end
    end
  end
end
