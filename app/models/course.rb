# frozen_string_literal: true

class Course < ApplicationRecord
  has_many :enrollments, dependent: :destroy
  has_many :talents, through: :enrollments
  has_many :learning_path_courses, dependent: :destroy
  has_many :learning_paths, through: :learning_path_courses

  validates :title, :credit_hours, :author_id, presence: true
  validates :code, presence: true, uniqueness: true
end
