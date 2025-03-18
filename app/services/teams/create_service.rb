module Teams
  class CreateService < ApplicationService
    def initialize(params:, user:)
      @params = params
      @user = user
    end

    def call
      team = @user.created_teams.new(@params)
      return handler_success(team) if team.save

      handler_failure(team.errors)
    end
  end
end
