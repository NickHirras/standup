class UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = current_company&.users&.includes(:teams, :work_schedule) || []
  end

  def show
    @teams = @user.teams.includes(:ceremonies)
    @work_schedule = @user.work_schedule
    @recent_responses = @user.responses.includes(:ceremony, :question).recent.limit(10)
  end

  def new
    @user = current_company&.users&.build || User.new
  end

  def create
    @user = current_company&.users&.build(user_params)
    
    if @user&.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully deleted.'
  end

  private

  def set_user
    @user = current_company&.users&.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :timezone, :notification_preferences)
  end
end
