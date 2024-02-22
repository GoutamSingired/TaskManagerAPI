# app/models/task.rb
class Task < ApplicationRecord
  # Validations
  belongs_to :user, optional: true

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true
  validates :due_date, presence: true
  validates :status, inclusion: { in: %w[Pending In-Progress Completed], message: "%{value} is not a valid status" }

  # Custom validation for completed_date when status is changed to "Completed"
  validate :completed_date_presence, if: -> { status_changed? && status == "Completed" }


  before_validation :set_default_progress, if: :update_progress?
  validates :progress, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, if: :update_progress?


  scope :overdue, -> { where("due_date < ?", Date.current) }


  private

  # Custom validation method to ensure completed_date is set when status is "Completed"
  def completed_date_presence
    errors.add(:completed_date, "can't be blank when status is Completed") if completed_date.blank?
  end

  def update_progress?
    @update_progress
  end

  def set_default_progress
    self.progress ||= 0
  end
end
