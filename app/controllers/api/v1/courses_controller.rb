# frozen_string_literal: true

module Api
  module V1
    class CoursesController < ApplicationController
      before_action :set_course, only: [:show, :update, :destroy]

      def index
        @courses = Course.all
        render json: @courses
      end

      def show
        render json: @course
      end

      def create
        @course = Course.new(course_params)
        if @course.save
          render json: @course, status: :created
        else
          render json: { errors: @course.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @course.update(course_params)
          render json: @course
        else
          render json: { errors: @course.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @course.destroy
        head :no_content
      end

      def complete_course
        talent = Talent.find(params[:talent_id])
        course = Course.find(params[:id])

        ActiveRecord::Base.transaction do
          enrollment = talent.enrollments.find_by(course:)

          # Check if the course is already complete
          if enrollment.status == 'complete'
            render json: { message: 'Course is already complete' }
            return
          end

          enrollment.update!(status: :complete)
          # Check if all courses in the learning path are complete
          learning_path = course.learning_paths&.first
          if learning_path && learning_path.courses.all? { |course| talent.enrollments.find_by(course:)&.status == 'complete' }
            learning_path.update!(status: :complete)
            render json: { message: 'Learning path is complete' }
          else
            # Check if there is a next course in the learning path and enroll in it
            current_seq = learning_path.learning_path_courses.where(course_id: course.id)&.first&.sequence
            next_course = learning_path.learning_path_courses.where(sequence: current_seq + 1)&.first&.course
            talent.enrollments.create!(course: next_course, status: :in_progress) if next_course

            render json: enrollment
          end
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Talent or Course not found' }, status: :not_found
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def enroll
        talent = Talent.find(params[:talent_id])
        course = Course.find(params[:id])

        if talent.courses.include?(course)
          render json: { error: 'Talent is already enrolled in this course' }, status: :unprocessable_entity
          return
        end

        ActiveRecord::Base.transaction do
          # Enroll talent in the course
          enrollment = talent.enrollments.create!(course:, status: :in_progress)
          render json: enrollment, status: :created
        rescue ActiveRecord::RecordInvalid => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Talent or Course not found' }, status: :not_found
      end

      private

      def set_course
        @course = Course.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Course not found' }, status: :not_found
      end

      def course_params
        params.require(:course).permit(:title, :code, :credit_hours, :author_id)
      end
    end
  end
end
