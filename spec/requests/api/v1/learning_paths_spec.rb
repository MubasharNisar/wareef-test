# spec/requests/learning_paths_spec.rb

require 'swagger_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'LearningPaths', type: :request do
  path '/learning_paths' do
    get 'Retrieves all learning paths' do
      tags 'Learning Paths'
      produces 'application/json'

      response '200', 'learning paths found' do
        run_test!
      end
    end

    path '/learning_paths' do
      post 'Creates a learning path' do
        tags 'Learning Paths'
        consumes 'application/json'
        produces 'application/json'
        parameter name: :learning_path, in: :body, schema: {
          type: :object,
          properties: {
            title: { type: :string },
            sequenced_courses: {
              type: :array,
              items: { type: :integer },
              description: 'Array of course IDs in sequence'
            }
          },
          required: %w[title sequenced_courses]
        }

        response '201', 'learning path created' do
          let(:learning_path) { { title: 'New Learning Path', sequenced_courses: [create(:course).id, create(:course).id] } }
          run_test!
        end

        response '422', 'invalid request' do
          let(:learning_path) { { title: nil, sequenced_courses: [] } }
          run_test!
        end
      end
    end
  end

  path '/learning_paths/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true

    get 'Retrieves a learning path' do
      tags 'Learning Paths'
      produces 'application/json'
      response '200', 'learning path found' do
        let(:id) { create(:learning_path).id }
        run_test!
      end

      response '404', 'learning path not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    put 'Updates a learning path' do
      tags 'Learning Paths'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :learning_path, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string }
        },
        required: ['title']
      }

      response '200', 'learning path updated' do
        let(:id) { create(:learning_path).id }
        let(:learning_path) { { title: 'Updated Learning Path' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { create(:learning_path).id }
        let(:learning_path) { { title: nil } }
        run_test!
      end

      response '404', 'learning path not found' do
        let(:id) { 0 }
        let(:learning_path) { { title: 'Updated Learning Path' } }
        run_test!
      end
    end

    delete 'Deletes a learning path' do
      tags 'Learning Paths'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true

      response '204', 'learning path deleted' do
        let(:id) { create(:learning_path).id }
        run_test!
      end

      response '404', 'learning path not found' do
        let(:id) { 0 }
        run_test!
      end
    end
  end
  path '/learning_paths/{id}/enroll' do
    parameter name: :id, in: :path, type: :integer, required: true

    post 'Enroll talent in a learning path' do
      tags 'Learning Paths'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :talent_id, in: :query, type: :integer, required: true

      response '201', 'talent enrolled in learning path' do
        let(:id) { create(:learning_path).id }
        let(:talent_id) { create(:talent).id }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { create(:learning_path).id }
        let(:talent_id) { nil }
        run_test!
      end

      response '404', 'learning path not found' do
        let(:id) { 0 }
        let(:talent_id) { create(:talent).id }
        run_test!
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
