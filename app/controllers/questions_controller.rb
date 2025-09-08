class QuestionsController < ApplicationController
  before_action :set_team
  before_action :set_ceremony
  before_action :set_question, only: [ :show, :edit, :update, :destroy ]
  before_action :require_team_manager

  def index
    @questions = @ceremony.questions.ordered
  end

  def show
  end

  def new
    @question = @ceremony.questions.build
    @question.order = (@ceremony.questions.maximum(:order) || 0) + 1
  end

  def create
    @question = @ceremony.questions.build(question_params)

    if @question.save
      redirect_to team_ceremony_questions_path(@team, @ceremony), notice: "Question was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to team_ceremony_questions_path(@team, @ceremony), notice: "Question was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    redirect_to team_ceremony_questions_path(@team, @ceremony), notice: "Question was successfully deleted."
  end

  def reorder
    questions_data = params[:questions]

    if questions_data.present?
      ActiveRecord::Base.transaction do
        questions_data.each do |question_data|
          question = @ceremony.questions.find(question_data[:id])
          question.update!(order: question_data[:order])
        end
        render json: { success: true }
      end
    else
      render json: { success: false, error: "No questions data provided" }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { success: false, error: "Question not found" }, status: :not_found
  rescue StandardError => e
    render json: { success: false, error: "Failed to reorder questions" }, status: :unprocessable_entity
  end

  private

  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_ceremony
    @ceremony = @team.ceremonies.find(params[:ceremony_id])
  end

  def set_question
    @question = @ceremony.questions.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:question_text, :question_type, :options, :required, :order)
  end
end
