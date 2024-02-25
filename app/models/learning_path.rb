class LearningPath < ApplicationRecord
  has_many :courses, -> { order(:sequence) }
end
