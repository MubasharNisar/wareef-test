# frozen_string_literal: true

class LearningPath < ApplicationRecord
  has_many :learning_path_courses, dependent: :destroy
  has_many :courses, through: :learning_path_courses
  has_many :learning_path_enrollments, dependent: :destroy
  has_many :talents, through: :learning_path_enrollments

  validates :title, presence: true
end
