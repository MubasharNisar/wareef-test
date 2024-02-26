# frozen_string_literal: true

module Api
  module V1
    class TalentsController < ApplicationController
      before_action :set_talent, only: [:show, :update, :destroy]

      # GET /talents
      def index
        talents = Talent.all
        render json: talents
      end

      # GET /talents/1
      def show
        render json: talent
      end

      # POST /talents
      def create
        talent = Talent.new(talent_params)

        if talent.save
          render json: talent, status: :created
        else
          render json: talent.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /talents/1
      def update
        if @talent.update(talent_params)
          render json: @talent
        else
          render json: @talent.errors, status: :unprocessable_entity
        end
      end

      # DELETE /talents/1
      def destroy
        if @talent.destroy
          render json: { message: 'Talent deleted successfully.' }, status: :ok
        else
          render json: { error: 'Failed to delete talent.' }, status: :unprocessable_entity
        end
      end

      def become_author
        talent = Talent.find(params[:id])

        # Check if the talent is not already an author
        if talent.author.present?
          render json: { message: "Talent is already an author." }, status: :unprocessable_entity
          return
        end

        # Create a new author with the same name as the talent
        author = Author.create(name: talent.name, email: talent.email)

        # Update the talent with the author association
        talent.update(author:)

        render json: { message: "Talent is now an author.", talent: }, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { message: "Talent not found." }, status: :not_found
      end

      private

      def set_talent
        @talent = Talent.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { message: e.message }, status: :not_found
      end

      def talent_params
        params.require(:talent).permit(:name, :email) # Add other permitted attributes
      end
    end
  end
end
