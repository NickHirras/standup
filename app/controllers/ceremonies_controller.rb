class CeremoniesController < ApplicationController
  before_action :set_team
  before_action :set_ceremony, only: [ :show, :edit, :update, :destroy, :participate, :submit_responses, :responses ]
  before_action :require_team_manager, only: [ :edit, :update, :destroy ]
  before_action :require_team_member, only: [ :participate, :submit_responses ]

  def index
    @ceremonies = @team.ceremonies.includes(:questions)
  end

  def show
    @questions = @ceremony.questions.ordered
    @responses = @ceremony.responses.for_today.includes(:user, :question)
    @completion_rate = @ceremony.completion_rate_for_today
    @pending_members = @ceremony.pending_members_for_today
  end

  def new
    @ceremony = @team.ceremonies.build
  end

  def create
    @ceremony = @team.ceremonies.build(ceremony_params)

    if @ceremony.save
      redirect_to team_ceremony_path(@team, @ceremony), notice: "Ceremony was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @questions = @ceremony.questions.ordered
  end

  def update
    if @ceremony.update(ceremony_params)
      redirect_to team_ceremony_path(@team, @ceremony), notice: "Ceremony was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @ceremony.destroy
    redirect_to team_ceremonies_path(@team), notice: "Ceremony was successfully deleted."
  end

  def participate
    @questions = @ceremony.questions.ordered
    @existing_responses = @ceremony.responses.where(user: current_user, submitted_at: Time.current.beginning_of_day..Time.current.end_of_day)
  end

  def submit_responses
    success = true

    params[:responses]&.each do |question_id, answer|
      question = @ceremony.questions.find(question_id)
      response = @ceremony.responses.find_or_initialize_by(
        user: current_user,
        question: question,
        submitted_at: Time.current.beginning_of_day..Time.current.end_of_day
      )

      unless response.update(answer: answer)
        success = false
        break
      end
    end

    if success
      redirect_to team_ceremony_path(@team, @ceremony), notice: "Your responses have been submitted successfully."
    else
      redirect_to participate_team_ceremony_path(@team, @ceremony), alert: "Failed to submit responses. Please try again."
    end
  end

  def responses
    @responses = @ceremony.responses.for_today.includes(:user, :question).order(:submitted_at)
    @questions = @ceremony.questions.ordered
  end

  private

  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_ceremony
    @ceremony = @team.ceremonies.find(params[:id])
  end

  def ceremony_params
    params.require(:ceremony).permit(:name, :description, :cadence, :scheduled_time, :timezone, :active)
  end
end
