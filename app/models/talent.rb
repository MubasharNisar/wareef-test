# frozen_string_literal: true

class Talent < ApplicationRecord
  has_many :enrollments, dependent: :destroy
  has_many :courses, through: :enrollments
  belongs_to :author, optional: true
  # has_many :authored_courses, class_name: 'Course', foreign_key: 'author_id'
  has_many :learning_path_enrollments, dependent: :destroy
  has_many :learning_paths, through: :learning_path_enrollments
  has_many :enrolled_courses, through: :enrollments, source: :course

  def mark_course_completed
    talent = Talent.find(params[:talent_id])
    course = Course.find(params[:course_id])

    # Your logic to mark the course as completed for the talent
    talent.courses << course

    # Update the status of the course to complete
    course.update(status: :complete)

    render json: { message: 'Course marked as completed for the talent' }
  end
end
