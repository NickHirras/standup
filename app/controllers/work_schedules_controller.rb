class WorkSchedulesController < ApplicationController
  before_action :set_work_schedule, only: [:show, :edit, :update]

  def show
    redirect_to new_work_schedule_path unless @work_schedule
  end

  def new
    @work_schedule = current_user.build_work_schedule
  end

  def create
    @work_schedule = current_user.build_work_schedule(work_schedule_params)
    
    if @work_schedule.save
      redirect_to dashboard_path, notice: 'Work schedule was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    redirect_to new_work_schedule_path unless @work_schedule
  end

  def update
    if @work_schedule.update(work_schedule_params)
      redirect_to dashboard_path, notice: 'Work schedule was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_work_schedule
    @work_schedule = current_user.work_schedule
  end

  def work_schedule_params
    params.require(:work_schedule).permit(:start_time, :end_time, :timezone, :days_of_week)
  end
end
