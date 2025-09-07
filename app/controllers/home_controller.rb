class HomeController < ApplicationController
  def index
    if user_signed_in?
      @user = current_user
      @teams = current_user.teams.includes(:ceremonies) || []
      @pending_ceremonies = current_user.teams.joins(:ceremonies)
                                      .where(ceremonies: { active: true })
                                      .distinct || []
      @recent_responses = current_user.responses.includes(:ceremony, :question)
                                     .recent.limit(5) || []
      @managed_teams = current_user.managed_teams || []
    end
  end

  def dashboard
    redirect_to root_path unless user_signed_in?
    
    @user = current_user
    @teams = current_user.teams.includes(:ceremonies) || []
    @today_ceremonies = @teams.flat_map(&:active_ceremonies).select(&:due_today?) || []
    @pending_responses = @today_ceremonies.flat_map(&:pending_members_for_today)
                                        .uniq
                                        .select { |member| member == current_user } || []
    @recent_responses = current_user.responses.includes(:ceremony, :question)
                                   .recent.limit(5) || []
  end

end
