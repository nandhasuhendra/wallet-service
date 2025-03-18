module API
  module V1
    module Users
      class WalletsController < ApplicationController
        def index
          @wallets = WalletRepository.owner_wallets(current_user)
        end

        def create
          service = ::Wallets::CreateAdditionalWalletService.call(owner: current_user, name: wallet_params[:name])
          unless service.success?
            render json: { errors: service.errors }, status: :unprocessable_entity
            return
          end

          @wallet = service.data
          render :show, status: :created
        end

        def show
          @wallet = WalletRepository.find_by_id_and_owner(params[:id], current_user)
          if @wallet
            render json: { errors: "wallet not found" }, status: :not_found
            return
          end
        end

        def update
          service = ::Wallets::UpdateService.call(wallet_id: params[:id], owner: current_user, name: wallet_params[:name], balance: wallet_params[:balance])
          unless service.success?
            render json: { errors: service.errors }, status: :unprocessable_entity
            return
          end

          @wallet = service.data
          render :show, status: :ok
        end

        def destroy
          wallet = WalletRepository.find_by_id_and_owner(params[:id], current_user)
          if wallet&.destroy!
            head :no_content
          end
        end

        private

        def wallet_params
          params.require(:wallet).permit(:name, :balance)
        end
      end
    end
  end
end

