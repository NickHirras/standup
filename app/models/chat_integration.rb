class ChatIntegration < ApplicationRecord
  # Associations
  belongs_to :company
  has_many :team_chat_configs, dependent: :destroy

  # Validations
  validates :company, presence: true
  validates :platform, presence: true, inclusion: { in: %w[slack google_chat microsoft_teams] }
  validates :config, presence: true

  # Scopes
  scope :active, -> { where(active: true) }
  scope :by_platform, ->(platform) { where(platform: platform) }

  # Enums
  enum :platform, { slack: "slack", google_chat: "google_chat", microsoft_teams: "microsoft_teams" }

  # Methods
  def config_hash
    return {} if config.blank?
    JSON.parse(config)
  rescue JSON::ParserError
    {}
  end

  def update_config(key, value)
    current_config = config_hash
    current_config[key] = value
    update(config: current_config.to_json)
  end

  def get_config(key, default = nil)
    current_config = config_hash
    current_config[key] || default
  end

  def platform_display_name
    case platform
    when "slack"
      "Slack"
    when "google_chat"
      "Google Chat"
    when "microsoft_teams"
      "Microsoft Teams"
    else
      platform.titleize
    end
  end

  def test_connection
    case platform
    when "slack"
      test_slack_connection
    when "google_chat"
      test_google_chat_connection
    when "microsoft_teams"
      test_microsoft_teams_connection
    else
      false
    end
  rescue => e
    Rails.logger.error "Chat integration test failed: #{e.message}"
    false
  end

  def send_message(chat_space_id, message)
    case platform
    when "slack"
      send_slack_message(chat_space_id, message)
    when "google_chat"
      send_google_chat_message(chat_space_id, message)
    when "microsoft_teams"
      send_microsoft_teams_message(chat_space_id, message)
    else
      false
    end
  rescue => e
    Rails.logger.error "Failed to send message via #{platform}: #{e.message}"
    false
  end

  private

  def test_slack_connection
    # Implementation for testing Slack connection
    # This would use the slack-ruby-client gem
    true
  end

  def test_google_chat_connection
    # Implementation for testing Google Chat connection
    # This would use the google-apis-chat_v1 gem
    true
  end

  def test_microsoft_teams_connection
    # Implementation for testing Microsoft Teams connection
    # This would use the microsoft_graph gem
    true
  end

  def send_slack_message(chat_space_id, message)
    # Implementation for sending Slack message
    # This would use the slack-ruby-client gem
    true
  end

  def send_google_chat_message(chat_space_id, message)
    # Implementation for sending Google Chat message
    # This would use the google-apis-chat_v1 gem
    true
  end

  def send_microsoft_teams_message(chat_space_id, message)
    # Implementation for sending Microsoft Teams message
    # This would use the microsoft_graph gem
    true
  end
end
