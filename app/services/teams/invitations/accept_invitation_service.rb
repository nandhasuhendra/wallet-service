module Teams
  module Invitations
    class AcceptInvitationService < ApplicationService
      def initialize(token:)
        @token = token
      end

      def call
        invitation = Invitation.find_by(invitation_token: @token)
        return handler_failure("invitation not found") if invitation.blank?
        return handler_failure("invitation already accepted") if invitation.accepted?
        return handler_failure("invitation expired") if invitation.expired?
        return handler_failure(inivtation.errors) unless invitation.accept!

        handler_success(invitation)
      end
    end
  end
end
