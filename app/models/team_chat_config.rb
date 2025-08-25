class TeamChatConfig < ApplicationRecord
  # Associations
  belongs_to :team
  belongs_to :chat_integration

  # Validations
  validates :team, presence: true
  validates :chat_integration, presence: true
  validates :chat_space_id, presence: true
  validates :chat_space_name, presence: true
  validates :team_id, uniqueness: { scope: :chat_integration_id }

  # Scopes
  scope :active, -> { where(active: true) }
  scope :by_platform, ->(platform) { joins(:chat_integration).where(chat_integrations: { platform: platform }) }

  # Methods
  def platform
    chat_integration.platform
  end

  def platform_display_name
    chat_integration.platform_display_name
  end

  def send_notification(message)
    return false unless active?
    chat_integration.send_message(chat_space_id, message)
  end

  def test_connection
    return false unless active?
    chat_integration.test_connection
  end

  def formatted_chat_space
    "#{chat_space_name} (#{platform_display_name})"
  end

  def can_send_messages?
    active? && chat_integration.active?
  end
end
