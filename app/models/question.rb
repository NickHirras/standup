class Question < ApplicationRecord
  # Associations
  belongs_to :ceremony
  has_many :responses, dependent: :destroy

  # Validations
  validates :question_text, presence: true
  validates :question_type, presence: true, inclusion: { in: %w[short_answer paragraph multiple_choice checkboxes dropdown file_upload linear_scale multiple_choice_grid checkbox_grid date time] }
  validates :order, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :ceremony, presence: true

  # Scopes
  scope :ordered, -> { order(:order) }
  scope :required, -> { where(required: true) }
  scope :optional, -> { where(required: false) }

  # Enums
  enum :question_type, {
    short_answer: "short_answer",
    paragraph: "paragraph",
    multiple_choice: "multiple_choice",
    checkboxes: "checkboxes",
    dropdown: "dropdown",
    file_upload: "file_upload",
    linear_scale: "linear_scale",
    multiple_choice_grid: "multiple_choice_grid",
    checkbox_grid: "checkbox_grid",
    date: "date",
    time: "time"
  }

  # Methods
  def options_array
    return [] if options.blank?

    begin
      parsed = JSON.parse(options)
      Rails.logger.debug "Question #{id}: Parsed options from '#{options}' to #{parsed.inspect}"
      parsed
    rescue JSON::ParserError => e
      Rails.logger.error "Question #{id}: Failed to parse options '#{options}': #{e.message}"
      []
    end
  end

  def text_based?
    %w[short_answer paragraph].include?(question_type)
  end

  def choice_based?
    %w[multiple_choice checkboxes dropdown].include?(question_type)
  end

  def grid_based?
    %w[multiple_choice_grid checkbox_grid].include?(question_type)
  end

  def date_time_based?
    %w[date time].include?(question_type)
  end

  def file_based?
    question_type == "file_upload"
  end

  def scale_based?
    question_type == "linear_scale"
  end

  def requires_options?
    choice_based? || grid_based?
  end

  def has_options?
    options_array.any?
  end

  def next_order
    ceremony.questions.maximum(:order) || 0 + 1
  end

  def reorder!(new_order)
    return if new_order == order

    if new_order < order
      ceremony.questions.where("order >= ? AND order < ?", new_order, order).update_all("order = order + 1")
    else
      ceremony.questions.where("order > ? AND order <= ?", order, new_order).update_all("order = order - 1")
    end

    update!(order: new_order)
  end
end
