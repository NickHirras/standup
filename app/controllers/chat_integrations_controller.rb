class ChatIntegrationsController < ApplicationController
  before_action :require_admin
  before_action :set_chat_integration, only: [:show, :edit, :update, :destroy, :test_connection]

  def index
    @chat_integrations = current_company&.chat_integrations&.includes(:team_chat_configs) || []
  end

  def show
    @team_configs = @chat_integration.team_chat_configs.includes(:team)
  end

  def new
    @chat_integration = current_company&.chat_integrations&.build || ChatIntegration.new
  end

  def create
    @chat_integration = current_company&.chat_integrations&.build(chat_integration_params)
    
    if @chat_integration&.save
      redirect_to @chat_integration, notice: 'Chat integration was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @chat_integration.update(chat_integration_params)
      redirect_to @chat_integration, notice: 'Chat integration was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @chat_integration.destroy
    redirect_to chat_integrations_url, notice: 'Chat integration was successfully deleted.'
  end

  def test_connection
    if @chat_integration.test_connection
      render json: { success: true, message: 'Connection test successful!' }
    else
      render json: { success: false, message: 'Connection test failed. Please check your configuration.' }
    end
  end

  private

  def set_chat_integration
    @chat_integration = current_company&.chat_integrations&.find(params[:id])
  end

  def chat_integration_params
    params.require(:chat_integration).permit(:platform, :config, :active)
  end
end
