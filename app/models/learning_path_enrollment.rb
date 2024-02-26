# app/models/learning_path_enrollment.rb
class LearningPathEnrollment < ApplicationRecord
  belongs_to :talent
  belongs_to :learning_path
  enum status: { in_progress: 0, complete: 1 }
end
