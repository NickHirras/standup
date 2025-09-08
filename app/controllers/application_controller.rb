class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name, :company_id, :role, :timezone ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :first_name, :last_name, :timezone ])
  end

  private

  helper_method :current_company

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end

  def current_company
    @current_company ||= current_user&.company
  end

  def current_company!
    current_company || raise(StandardError, "No company associated with current user")
  end

  def require_admin
    unless current_user&.admin?
      flash[:alert] = "You must be an administrator to access this page."
      redirect_to root_path
    end
  end

  def require_team_manager
    # This method can be called without arguments from before_action
    # It will use the @team instance variable set by the controller
    team = instance_variable_get(:@team)
    unless team && current_user&.team_manager?(team)
      flash[:alert] = "You must be a team manager to perform this action."
      redirect_to team_path(team) if team
      redirect_to root_path unless team
    end
  end

  def require_team_member
    # This method can be called without arguments from before_action
    # It will use the @team instance variable set by the controller
    team = instance_variable_get(:@team)
    unless team && current_user&.team_member?(team)
      flash[:alert] = "You must be a team member to access this page."
      redirect_to root_path
    end
  end
end
