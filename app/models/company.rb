class Company < ApplicationRecord
  # Associations
  has_many :users, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :chat_integrations, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :domain, presence: true, uniqueness: true

  # Methods
  def settings_hash
    return {} if settings.blank?
    JSON.parse(settings)
  rescue JSON::ParserError
    {}
  end

  def update_setting(key, value)
    current_settings = settings_hash
    current_settings[key] = value
    update(settings: current_settings.to_json)
  end

  def get_setting(key, default = nil)
    settings_hash[key] || default
  end

  def admins
    users.admins
  end

  def active_chat_integrations
    chat_integrations.where(active: true)
  end

  def chat_integration_for(platform)
    chat_integrations.find_by(platform: platform, active: true)
  end
end
