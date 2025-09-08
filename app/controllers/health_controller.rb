class HealthController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    render json: { status: "ok", timestamp: Time.current.iso8601 }
  end
end
