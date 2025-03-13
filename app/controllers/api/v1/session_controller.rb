module API
  module V1
    class SessionController < ApplicationController
      skip_before_action :authenticate_request

      def create
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = AuthToken.encode(user_id: user.id)
          render json: { token: token }
        else
          render json: { error: I18n.t("api.error_messages.invalid_credentials") }, status: :unauthorized
        end
      end
    end
  end
end
