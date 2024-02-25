# frozen_string_literal: true

class LearningPath < ApplicationRecord
  has_many :courses, -> { order(:sequence) }
end
