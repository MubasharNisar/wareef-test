# frozen_string_literal: true

class LearningPath < ApplicationRecord
  has_many :learning_path_courses
  has_many :courses, through: :learning_path_courses

  enum status: { in_progress: 0, complete: 1 }

  validates :title, presence: true
end
