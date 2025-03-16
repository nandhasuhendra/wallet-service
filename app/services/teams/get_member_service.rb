module Teams
  class GetMemberService < ApplicationService
    def initialize(team_id:)
      @team_id = team_id
    end

    def call
      Membership.includes(:user).where(team_id: @team_id)
    end
  end
end
