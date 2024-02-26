# spec/requests/courses_spec.rb

require 'swagger_helper'

# rubocop:disable Metrics/BlockLength
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
          author_id: { type: :integer },
          code: { type: :string },
          credit_hours: { type: :integer }
        },
        required: %w[title author_id code credit_hours]
      }

      response '201', 'course created' do
        let(:course) do
          {
            title: 'Course 101',
            author_id: create(:talent).id,
            code: 'ABC123',
            credit_hours: 3
          }
        end
        run_test!
      end

      response '422', 'invalid request' do
        let(:course) { { title: nil, author_id: nil, code: nil, credit_hours: nil } }
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
          author_id: { type: :integer },
          code: { type: :string },
          credit_hours: { type: :integer }
        },
        required: %w[title author_id code credit_hours]
      }

      response '200', 'course updated' do
        let(:id) { create(:course).id }
        let(:course) do
          {
            title: 'Updated Course',
            author_id: create(:talent).id,
            code: 'XYZ456',
            credit_hours: 4
          }
        end
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { create(:course).id }
        let(:course) { { title: nil, author_id: nil, code: nil, credit_hours: nil } }
        run_test!
      end

      response '404', 'course not found' do
        let(:id) { 0 }
        let(:course) do
          {
            title: 'Updated Course',
            author_id: create(:talent).id,
            code: 'XYZ456',
            credit_hours: 4
          }
        end
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

  path '/courses/{id}/enroll' do
    parameter name: :id, in: :path, type: :integer, required: true
    parameter name: :talent_id, in: :path, type: :integer, required: true

    post 'Enrolls a talent in a course' do
      tags 'Courses'
      consumes 'application/json'
      produces 'application/json'

      response '201', 'enrollment created' do
        let(:id) { create(:course).id }
        let(:talent_id) { create(:talent).id }
        run_test!
      end

      response '404', 'course or talent not found' do
        let(:id) { 0 }
        let(:talent_id) { 0 }
        run_test!
      end
    end
  end

  path '/courses/{id}/complete_course' do
    parameter name: :id, in: :path, type: :integer, required: true
    parameter name: :talent_id, in: :query, type: :integer, required: true

    post 'Completes a course for a talent' do
      tags 'Courses'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'course completed' do
        let(:id) { create(:course).id }
        let(:talent_id) { create(:talent).id }
        run_test!
      end

      response '404', 'course or talent not found' do
        let(:id) { 0 }
        let(:talent_id) { 0 }
        run_test!
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
