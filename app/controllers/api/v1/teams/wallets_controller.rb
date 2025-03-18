module API
  module V1
    module Teams
      class WalletsController < ApplicationController
        def show
          wallet = WalletRepository.find_by_id_and_owner(params[:id], current_team)
          if @wallet
            render json: { errors: "wallet not found" }, status: :not_found
            return
          end
        end

        private

        def current_team
          @current_team ||= current_user.teams.find(params[:team_id])
        end
      end
    end
  end
end
