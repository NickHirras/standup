class UserWorkSchedule < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :user, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :timezone, presence: true
  validates :days_of_week, presence: true
  validate :end_time_after_start_time
  validate :valid_days_of_week

  # Scopes
  scope :active, -> { where(active: true) }

  # Methods
  def work_hours
    "#{start_time.strftime('%I:%M %p')} - #{end_time.strftime('%I:%M %p')}"
  end

  def work_days_array
    return [] if days_of_week.blank?
    JSON.parse(days_of_week)
  rescue JSON::ParserError
    []
  end

  def work_days_display
    days = work_days_array
    return "Not set" if days.empty?

    day_names = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
    selected_days = days.map { |day| day_names[day.to_i - 1] }
    selected_days.join(", ")
  end

  def working_today?
    today = Date.current.wday
    work_days_array.include?(today.to_s)
  end

  def working_now?
    return false unless working_today?

    current_time = Time.current.in_time_zone(timezone).time
    start_time <= current_time && current_time <= end_time
  end

  def next_work_start
    return nil unless working_today?

    today = Date.current
    Time.zone.parse("#{today} #{start_time}").in_time_zone(timezone)
  end

  def next_work_end
    return nil unless working_today?

    today = Date.current
    Time.zone.parse("#{today} #{end_time}").in_time_zone(timezone)
  end

  def time_until_work_start
    return nil unless working_today?

    next_start = next_work_start
    return 0 if next_start <= Time.current

    (next_start - Time.current).to_i / 60 # minutes
  end

  def time_until_work_end
    return nil unless working_today?

    next_end = next_work_end
    return 0 if next_end <= Time.current

    (next_end - Time.current).to_i / 60 # minutes
  end

  private

  def end_time_after_start_time
    return unless start_time && end_time

    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end

  def valid_days_of_week
    return unless days_of_week.present?

    begin
      days = JSON.parse(days_of_week)
      unless days.is_a?(Array) && days.all? { |day| day.to_s.match?(/^[1-7]$/) }
        errors.add(:days_of_week, "must be an array of numbers 1-7 representing days of the week")
      end
    rescue JSON::ParserError
      errors.add(:days_of_week, "must be valid JSON")
    end
  end
end
