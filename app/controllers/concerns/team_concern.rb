module TeamConcern
  extend ActiveSupport::Concern

  def current_team
    @current_team ||= current_user.teams.find(params[:team_id])
  end
end
