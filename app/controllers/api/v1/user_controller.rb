module API
  module V1
    class UserController < ApplicationController
      def show
        render json: current_user, status: 200
      end
    end
  end
end
