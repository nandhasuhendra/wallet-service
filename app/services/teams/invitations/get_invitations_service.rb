module Teams
  module Invitations
    class GetInvitationsService < ApplicationService
      def initialize(team_id:, limit: 20)
        @team_id = team_id
        @limit = limit
      end

      def call
        Invitation.includes(:team, :sender, :recipient)
                  .where(team_id: @team_id)
                  .limit(20)
                  .order(created_at: :desc)
      end
    end
  end
end
