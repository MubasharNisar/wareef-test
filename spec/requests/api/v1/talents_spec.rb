# spec/requests/talents_spec.rb

require 'swagger_helper'

RSpec.describe 'Talents', type: :request do
  path '/talents' do
    get 'Retrieves all talents' do
      tags 'Talents'
      produces 'application/json'

      response '200', 'talents found' do
        run_test!
      end
    end

    post 'Creates a talent' do
      tags 'Talents'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :talent, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string }
          # Add other attributes as needed
        },
        required: %w[name email]
      }

      response '201', 'talent created' do
        let(:talent) { { name: 'John Doe', email: 'john.doe@example.com' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:talent) { { name: nil, email: nil } }
        run_test!
      end
    end
  end

  path '/talents/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true

    get 'Retrieves a talent' do
      tags 'Talents'
      produces 'application/json'
      response '200', 'talent found' do
        let(:id) { create(:talent).id }
        run_test!
      end

      response '404', 'talent not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    put 'Updates a talent' do
      tags 'Talents'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :talent, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string }
          # Add other attributes as needed
        },
        required: %w[name email]
      }

      response '200', 'talent updated' do
        let(:id) { create(:talent).id }
        let(:talent) { { name: 'Updated Talent', email: 'updated.talent@example.com' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { create(:talent).id }
        let(:talent) { { name: nil, email: nil } }
        run_test!
      end

      response '404', 'talent not found' do
        let(:id) { 0 }
        let(:talent) { { name: 'Updated Talent', email: 'updated.talent@example.com' } }
        run_test!
      end
    end

    delete 'Deletes a talent' do
      tags 'Talents'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true

      response '200', 'talent deleted successfully' do
        let(:id) { create(:talent).id }
        run_test!
      end

      response '404', 'talent not found' do
        let(:id) { 0 }
        run_test!
      end
    end
  end
  path '/talents/{id}/become_author' do
    parameter name: :id, in: :path, type: :integer, required: true

    post 'Become an author' do
      tags 'Talents'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'talent became an author' do
        let(:id) { create(:talent).id }
        run_test!
      end

      response '404', 'talent not found' do
        let(:id) { 0 }
        run_test!
      end

      response '422', 'talent is already an author' do
        let(:id) { create(:author).talent.id }
        run_test!
      end
    end
  end
end
