# spec/requests/authors_spec.rb

require 'swagger_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Authors', type: :request do
  path '/authors' do
    get 'Retrieves all authors' do
      tags 'Authors'
      produces 'application/json'

      response '200', 'authors found' do
        run_test!
      end
    end

    post 'Creates an author' do
      tags 'Authors'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :author, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string }
          # Add other attributes as needed
        },
        required: %w[name email]
      }

      response '201', 'author created' do
        let(:author) { { name: 'John Doe', email: 'john.doe@example.com' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:author) { { name: nil, email: nil } }
        run_test!
      end
    end
  end

  path '/authors/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true

    get 'Retrieves an author' do
      tags 'Authors'
      produces 'application/json'
      response '200', 'author found' do
        let(:id) { create(:author).id }
        run_test!
      end

      response '404', 'author not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    put 'Updates an author' do
      tags 'Authors'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :author, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string }
          # Add other attributes as needed
        },
        required: %w[name email]
      }

      response '200', 'author updated' do
        let(:id) { create(:author).id }
        let(:author) { { name: 'Updated Author', email: 'updated.author@example.com' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { create(:author).id }
        let(:author) { { name: nil, email: nil } }
        run_test!
      end

      response '404', 'author not found' do
        let(:id) { 0 }
        let(:author) { { name: 'Updated Author', email: 'updated.author@example.com' } }
        run_test!
      end
    end

    delete 'Deletes an author' do
      tags 'Authors'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true

      response '200', 'author deleted successfully' do
        let(:id) { create(:author).id }
        run_test!
      end

      response '404', 'author not found' do
        let(:id) { 0 }
        run_test!
      end

      response '422', 'no other author available to transfer courses' do
        let(:id) { create(:author).id }
        # Ensure there is no other author available to transfer courses
        before { Author.destroy_all }
        run_test!
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
