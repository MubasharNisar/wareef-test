# frozen_string_literal: true

class Course < ApplicationRecord
  belongs_to :author
  has_and_belongs_to_many :talents
  has_many :learning_path_courses
  has_many :learning_paths, through: :learning_path_courses

  enum status: { in_progress: 0, complete: 1 }

  validates :title, presence: true
end
