module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request
  end

  def current_user
    @current_user
  end

  def authenticate_request
    token = request.headers["Authorization"]&.split(" ")&.last
    decoded_token = AuthToken.decode(token)

    if !decoded_token
      render json: { error: I18n.t("api.error_messages.invalid_token") }, status: :unauthorized
      return
    end

    @current_user = User.find(decoded_token[:user_id])
  end
end
