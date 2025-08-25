class CompaniesController < ApplicationController
  before_action :require_admin
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  def index
    @companies = Company.all.includes(:users, :teams)
  end

  def show
    @users = @company.users.includes(:teams)
    @teams = @company.teams.includes(:users)
    @chat_integrations = @company.chat_integrations
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    
    if @company.save
      redirect_to @company, notice: 'Company was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @company.update(company_params)
      redirect_to @company, notice: 'Company was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @company.destroy
    redirect_to companies_url, notice: 'Company was successfully deleted.'
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :domain, :settings)
  end
end
