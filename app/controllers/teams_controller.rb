class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy, :manage_members, :add_member, :remove_member]
  before_action :require_team_manager, only: [:edit, :update, :destroy, :manage_members, :add_member, :remove_member]

  def index
    if current_user.admin?
      @teams = Team.all.includes(:company, :users)
    else
      @teams = current_user.teams.includes(:company, :users)
    end
  end

  def show
    @ceremonies = @team.ceremonies.includes(:questions)
    @members = @team.team_memberships.includes(:user)
    @managers = @team.managers
    @regular_members = @team.regular_members
  end

  def new
    @team = Team.new
    @team.company = current_company
  end

  def create
    @team = current_company.teams.build(team_params)
    
    if @team.save
      # Add the creator as a manager
      @team.add_member(current_user, role: 'manager')
      redirect_to @team, notice: 'Team was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @team.update(team_params)
      redirect_to @team, notice: 'Team was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_url, notice: 'Team was successfully deleted.'
  end

  def manage_members
    @members = @team.team_memberships.includes(:user)
    @available_users = current_company.users.where.not(id: @team.user_ids)
  end

  def add_member
    user = current_company.users.find(params[:user_id])
    role = params[:role] || 'member'
    
    if @team.add_member(user, role: role)
      redirect_to manage_members_team_path(@team), notice: "#{user.full_name} was added to the team."
    else
      redirect_to manage_members_team_path(@team), alert: 'Failed to add member to team.'
    end
  end

  def remove_member
    user = current_company.users.find(params[:user_id])
    
    if @team.remove_member(user)
      redirect_to manage_members_team_path(@team), notice: "#{user.full_name} was removed from the team."
    else
      redirect_to manage_members_team_path(@team), alert: 'Failed to remove member from team.'
    end
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name, :description)
  end
end
