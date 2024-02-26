# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/'
  mount Rswag::Api::Engine => '/api'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :talents do
        member do
          post 'become_author'
        end
      end
      resources :authors
      resources :courses do
        member do
          post :enroll
          post :complete_course
        end
      end
      resources :learning_paths do
        member do
          post :enroll
        end
      end
    end
  end
end
