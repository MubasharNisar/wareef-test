class LearningPathCourse < ApplicationRecord
  belongs_to :learning_path
  belongs_to :course

  validates :sequence, presence: true, numericality: { greater_than_or_equal_to: 1 }
end