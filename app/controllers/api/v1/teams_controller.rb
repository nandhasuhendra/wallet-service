module API
  module V1
    class TeamsController < ApplicationController
      include TeamConcern

      def create
        team = ::Teams::CreateService.call(params: team_params, user: current_user)
        unless team.success?
          render json: team.errors, status: :unprocessable_entity
          return
        end

        @team = team.data
        render :show
      end

      def show
        @team = current_team
      end

      def update
        team = ::Teams::UpdateService.call(id: params[:id], params: team_params, user: current_user)
        unless team.success?
          render json: team.errors, status: :unprocessable_entity
          return
        end

        @team = team.data
        render :show
      end

      private

      def team_params
        req_params = params.require(:team).permit(:name)
      end
    end
  end
end
