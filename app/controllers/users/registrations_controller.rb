class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :company_id, :role, :timezone])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :timezone])
  end

  def after_sign_up_path_for(resource)
    # Redirect to work schedule setup after successful registration
    new_work_schedule_path
  end

  def after_update_path_for(resource)
    dashboard_path
  end
end
