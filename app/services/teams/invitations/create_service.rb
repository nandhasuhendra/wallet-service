module Teams
  module Invitations
    class CreateInvitationService < ApplicationService
      def initialize(params:, sender:)
        @params = params
        @sender = sender
      end

      def call
        return handler_failure("recipient not found") if recipient.blank?
        return handler_failure("team not found") if team.blank?

        invitation = @team.invitations.new(sender: @sender, recipient: recipient)
        return hander_success(invitation) if invitation.save

        handler_failure(invitation.errors)
      end

      private

      def recipient
        @recipient ||= User.find_by(email: @params[:email])
      end

      def team
        @team ||= Team.find(@params[:team_id])
      end
    end
  end
end
