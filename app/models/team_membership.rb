class TeamMembership < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :team

  # Validations
  validates :user, presence: true
  validates :team, presence: true
  validates :role, presence: true, inclusion: { in: %w[member manager] }
  validates :user_id, uniqueness: { scope: :team_id }

  # Enums
  enum :role, { member: 'member', manager: 'manager' }

  # Scopes
  scope :managers, -> { where(role: 'manager') }
  scope :members, -> { where(role: 'member') }

  # Methods
  def manager?
    role == 'manager'
  end

  def member?
    role == 'member'
  end
end
