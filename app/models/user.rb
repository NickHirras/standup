class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  belongs_to :company
  has_many :team_memberships, dependent: :destroy
  has_many :teams, through: :team_memberships
  has_many :responses, dependent: :destroy
  has_one :work_schedule, class_name: 'UserWorkSchedule', dependent: :destroy

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, presence: true, inclusion: { in: %w[user admin] }
  validates :timezone, presence: true

  # Enums
  enum :role, { user: 'user', admin: 'admin' }

  # Scopes
  scope :admins, -> { where(role: 'admin') }
  scope :regular_users, -> { where(role: 'user') }

  # Methods
  def full_name
    "#{first_name} #{last_name}"
  end

  def admin?
    role == 'admin'
  end

  def team_manager?(team)
    team_memberships.find_by(team: team)&.role == 'manager'
  end

  def team_member?(team)
    team_memberships.exists?(team: team)
  end

  def managed_teams
    teams.joins(:team_memberships).where(team_memberships: { role: 'manager' })
  end

  def notification_preferences_hash
    return {} if notification_preferences.blank?
    JSON.parse(notification_preferences)
  rescue JSON::ParserError
    {}
  end

  def work_hours_start
    work_schedule&.start_time
  end

  def work_hours_end
    work_schedule&.end_time
  end

  def work_days
    return [] unless work_schedule&.days_of_week
    JSON.parse(work_schedule.days_of_week)
  rescue JSON::ParserError
    []
  end
end
