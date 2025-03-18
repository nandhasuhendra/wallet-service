module API
  module V1
    module Teams
      class WalletsController < ApplicationController
        include TeamConcern

        def show
          wallet = WalletRepository.find_by_id_and_owner(params[:id], current_team)
          if @wallet
            render json: { errors: "wallet not found" }, status: :not_found
            return
          end
        end
      end
    end
  end
end
