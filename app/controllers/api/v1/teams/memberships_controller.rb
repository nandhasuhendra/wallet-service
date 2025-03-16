module API
  module V1
    module Teams
      class MembershipsController < ApplicationController
        def index
          @memberships = ::Teams::GetMemberService.call(team_id: params[:team_id])
        end

        def destroy
          membership = Membership.find_by(team_id: params[:team_id], user_id: params[:id])
          membership.destroy!
          head :no_content
        end
      end
    end
  end
end
