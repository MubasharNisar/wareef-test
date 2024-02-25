# spec/requests/courses_spec.rb

require 'swagger_helper'

RSpec.describe 'Courses', type: :request do
  path '/courses' do
    get 'Retrieves all courses' do
      tags 'Courses'
      produces 'application/json'

      response '200', 'courses found' do
        run_test!
      end
    end

    post 'Creates a course' do
      tags 'Courses'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :course, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          learning_path_id: { type: :integer },
          author_id: { type: :integer }
        },
        required: ['title', 'learning_path_id', 'author_id']
      }

      response '201', 'course created' do
        let(:course) { { title: 'Course 101', learning_path_id: create(:learning_path).id, author_id: create(:talent).id } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:course) { { title: nil, learning_path_id: nil, author_id: nil } }
        run_test!
      end
    end
  end

  path '/courses/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true

    get 'Retrieves a course' do
      tags 'Courses'
      produces 'application/json'
      response '200', 'course found' do
        let(:id) { create(:course).id }
        run_test!
      end

      response '404', 'course not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    put 'Updates a course' do
      tags 'Courses'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :course, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          learning_path_id: { type: :integer },
          author_id: { type: :integer }
        },
        required: ['title', 'learning_path_id', 'author_id']
      }

      response '200', 'course updated' do
        let(:id) { create(:course).id }
        let(:course) { { title: 'Updated Course', learning_path_id: create(:learning_path).id, author_id: create(:talent).id } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { create(:course).id }
        let(:course) { { title: nil, learning_path_id: nil, author_id: nil } }
        run_test!
      end

      response '404', 'course not found' do
        let(:id) { 0 }
        let(:course) { { title: 'Updated Course', learning_path_id: create(:learning_path).id, author_id: create(:talent).id } }
        run_test!
      end
    end

    delete 'Deletes a course' do
      tags 'Courses'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true

      response '204', 'course deleted' do
        let(:id) { create(:course).id }
        run_test!
      end

      response '404', 'course not found' do
        let(:id) { 0 }
        run_test!
      end
    end
  end
end
