class Ceremony < ApplicationRecord
  # Associations
  belongs_to :team
  has_many :questions, -> { order(:order) }, dependent: :destroy
  has_many :responses, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :team, presence: true
  validates :cadence, presence: true, inclusion: { in: %w[daily weekly bi_weekly monthly custom] }
  validates :scheduled_time, presence: true
  validates :timezone, presence: true

  # Scopes
  scope :active, -> { where(active: true) }
  scope :scheduled_for_today, -> { where(active: true) }

  # Enums
  enum :cadence, { daily: 'daily', weekly: 'weekly', bi_weekly: 'bi_weekly', monthly: 'monthly', custom: 'custom' }

  # Methods
  def next_occurrence
    # This is a simplified version - in production you'd want more sophisticated scheduling logic
    case cadence
    when 'daily'
      Time.current.beginning_of_day + scheduled_time.seconds_since_midnight
    when 'weekly'
      Time.current.beginning_of_week + scheduled_time.seconds_since_midnight
    when 'bi_weekly'
      Time.current.beginning_of_week + scheduled_time.seconds_since_midnight + 1.week
    when 'monthly'
      Time.current.beginning_of_month + scheduled_time.seconds_since_midnight
    else
      Time.current.beginning_of_day + scheduled_time.seconds_since_midnight
    end
  end

  def due_today?
    next_occurrence.to_date == Date.current
  end

  def team_members
    team.all_members
  end

  def responses_for_today
    responses.where(submitted_at: Time.current.beginning_of_day..Time.current.end_of_day)
  end

  def completion_rate_for_today
    total_members = team_members.count
    return 0 if total_members.zero?
    
    (responses_for_today.count.to_f / total_members * 100).round(1)
  end

  def pending_members_for_today
    team_members.where.not(id: responses_for_today.select(:user_id))
  end

  def question_count
    questions.count
  end

  def required_questions
    questions.where(required: true)
  end

  def optional_questions
    questions.where(required: false)
  end
end
