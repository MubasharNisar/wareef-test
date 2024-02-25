# frozen_string_literal: true

module Api
  module V1
    class AuthorsController < ApplicationController
      before_action :set_author, only: [:show, :update, :destroy]

      # GET /authors
      def index
        @authors = Author.all
        render json: @authors
      end

      # GET /authors/1
      def show
        render json: @author
      end

      # POST /authors
      def create
        @author = Author.new(author_params)

        if @author.save
          render json: @author, status: :created
        else
          render json: @author.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /authors/1
      def update
        if @author.update(author_params)
          render json: @author
        else
          render json: @author.errors, status: :unprocessable_entity
        end
      end

      # DELETE /authors/1
      def destroy
        if @author.destroy
          render json: { message: 'Author deleted successfully. Courses transferred to another author.' }, status: :ok
        else
          render json: { error: 'No other author available to transfer courses.' }, status: :unprocessable_entity
        end
      end

      private

      def set_author
        @author = Author.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Author not found' }, status: :not_found
      end

      def author_params
        params.require(:author).permit(:name, :email)
      end

      def transfer_courses_before_destroy(author)
        # Find another author to transfer courses to
        new_author = Author.where.not(id: author.id).first

        return nil unless new_author

        # Transfer courses to the new author
        author.courses.update_all(author_id: new_author.id)
        new_author
      end
    end
  end
end
