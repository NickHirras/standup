class Team < ApplicationRecord
  # Associations
  belongs_to :company
  has_many :team_memberships, dependent: :destroy
  has_many :users, through: :team_memberships
  has_many :ceremonies, dependent: :destroy
  has_many :team_chat_configs, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :company, presence: true

  # Scopes
  scope :active, -> { where(active: true) }

  # Methods
  def managers
    users.joins(:team_memberships).where(team_memberships: { role: 'manager' })
  end

  def regular_members
    users.joins(:team_memberships).where(team_memberships: { role: 'member' })
  end

  def all_members
    users
  end

  def add_member(user, role: 'member')
    team_memberships.create(user: user, role: role)
  end

  def remove_member(user)
    team_memberships.find_by(user: user)&.destroy
  end

  def change_member_role(user, new_role)
    membership = team_memberships.find_by(user: user)
    membership&.update(role: new_role)
  end

  def active_ceremonies
    ceremonies.where(active: true)
  end

  def chat_config_for(platform)
    team_chat_configs.joins(:chat_integration).find_by(chat_integrations: { platform: platform, active: true })
  end

  def has_manager?(user)
    team_memberships.exists?(user: user, role: 'manager')
  end

  def has_member?(user)
    team_memberships.exists?(user: user)
  end
end
