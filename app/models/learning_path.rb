# frozen_string_literal: true

class LearningPath < ApplicationRecord
  has_many :courses, -> { order(:sequence) }

  enum status: { in_progress: 0, complete: 1 }
end
