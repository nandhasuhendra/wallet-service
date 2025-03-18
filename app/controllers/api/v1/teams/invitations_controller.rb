module API
  module V1
    module Teams
      class InvitationsController < ApplicationController
        def index
          @invitations = ::Teams::Invitations::GetInvitationsService.call(params[:team_id], limit: 20)
        end

        def create
          @invitation = ::Teams::Invitations::CreateInvitationService.call(params: invitation_params, sender: current_user)
          unless @invitation.success?
            render json: { errors: @invitation.errors }, status: :unprocessable_entity
            return
          end

          render :show
        end

        def destroy
          invitation = Invitation.find(params[:id])
          invitation.destroy!
          head :no_content
        end

        def accept
          @invitation = ::Teams::Invitations::AcceptInvitationService.call(token: params[:token])
          unless @invitation.success?
            head :accepted
            return
          end

          render :show
        end

        private

        def invitation_params
          params.require(:invitation).permit(:email, :team_id)
        end
      end
    end
  end
end
