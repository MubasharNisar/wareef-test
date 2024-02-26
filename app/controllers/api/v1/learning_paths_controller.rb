# frozen_string_literal: true

module Api
  module V1
    class LearningPathsController < ApplicationController
      before_action :set_learning_path, only: [:show, :update, :destroy]
      def index
        learning_paths = LearningPath.all
        render json: learning_paths
      end

      def show
        render json: @learning_path
      end

      def create
        @learning_path = LearningPath.new(learning_path_params)
        sequenced_courses_arr = params[:sequenced_courses]

        unless sequenced_courses_arr.any? && @learning_path.valid?
          render json: { message: "Missing required fields: title or sequenced_courses" }, status: :unprocessable_entity
          return
        end

        unless sequenced_courses_arr.uniq!.nil?
          render json: { message: "Duplicate course IDs found in sequenced_courses array" }, status: :unprocessable_entity
          return
        end

        courses = Course.where(id: sequenced_courses_arr)

        # Check if all courses exist
        unless courses.length == sequenced_courses_arr.length
          render json: { message: "Some specified courses do not exist" }, status: :not_found
          return
        end

        # Create learning path and associate courses with positions using transactions
        ActiveRecord::Base.transaction do
          @learning_path.save!
          sequenced_courses_arr.each_with_index do |course_id, sequence_num|
            LearningPathCourse.create!(learning_path: @learning_path, course: Course.find(course_id), sequence: sequence_num + 1)
          end
        end

        render json: @learning_path, include: [:courses], status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { message: e.message }, status: :unprocessable_entity
      rescue ActiveRecord::RecordNotFound => e
        render json: { message: e.message }, status: :not_found
      end

      def update
        if @learning_path.update(learning_path_params)
          render json: @learning_path
        else
          render json: { errors: @learning_path.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @learning_path.destroy
        head :no_content
      end

      def enroll
        talent = Talent.find(params[:talent_id])
        learning_path = LearningPath.find(params[:id])
      
        ActiveRecord::Base.transaction do
          if talent.learning_paths.include?(learning_path)
            render json: { error: 'Talent is already enrolled in this learning path' }, status: :unprocessable_entity
            return
          end
      
          # Enroll talent in learning path
          learning_path_enrollment = talent.learning_path_enrollments.create!(learning_path: learning_path, status: :in_progress)
      
          # Enroll talent in the first course of the learning path
          first_course = learning_path.courses.order(:sequence).first
          talent.enrollments.create!(course: first_course, status: :in_progress) if first_course
      
          render json: learning_path_enrollment, status: :created
        end
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private

      def learning_path_params
        params.require(:learning_path).permit(:title)
      end

      def set_learning_path
        @learning_path = LearningPath.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { message: e.message }, status: :not_found
      end
    end
  end
end
