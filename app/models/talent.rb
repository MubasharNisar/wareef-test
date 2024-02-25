# frozen_string_literal: true

class Talent < ApplicationRecord
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :learning_paths

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
