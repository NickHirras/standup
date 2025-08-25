class Response < ApplicationRecord
  # Associations
  belongs_to :ceremony
  belongs_to :user
  belongs_to :question

  # Validations
  validates :ceremony, presence: true
  validates :user, presence: true
  validates :question, presence: true
  validates :submitted_at, presence: true
  validates :user_id, uniqueness: { scope: [:ceremony_id, :question_id] }

  # Scopes
  scope :for_today, -> { where(submitted_at: Time.current.beginning_of_day..Time.current.end_of_day) }
  scope :recent, -> { order(submitted_at: :desc) }

  # Callbacks
  before_validation :set_submitted_at, on: :create

  # Methods
  def submitted_today?
    submitted_at.to_date == Date.current
  end

  def answer_present?
    answer.present?
  end

  def formatted_answer
    case question.question_type
    when 'date'
      Date.parse(answer).strftime('%B %d, %Y') rescue answer
    when 'time'
      Time.parse(answer).strftime('%I:%M %p') rescue answer
    when 'checkboxes'
      answer_array.join(', ')
    when 'multiple_choice_grid', 'checkbox_grid'
      format_grid_answer
    else
      answer
    end
  end

  def answer_array
    return [] if answer.blank?
    JSON.parse(answer)
  rescue JSON::ParserError
    [answer]
  end

  private

  def set_submitted_at
    self.submitted_at ||= Time.current
  end

  def format_grid_answer
    return answer unless answer.present?
    
    begin
      grid_data = JSON.parse(answer)
      if grid_data.is_a?(Hash)
        grid_data.map { |key, value| "#{key}: #{value}" }.join(', ')
      else
        answer
      end
    rescue JSON::ParserError
      answer
    end
  end
end
