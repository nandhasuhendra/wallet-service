module Teams
  class UpdateService < ApplicationService
    def initialize(id:, params:, user:)
      @id = id
      @params = params
      @user = user
    end

    def call
      team = Team.find(@id)
      return handler_failure('team not found') unless team
      return handler_failure('unauthorized') unless team.creator == @user
      return handler_failure(team.errors) unless team.update(@params)

      handler_success(team)
    end
  end
end
