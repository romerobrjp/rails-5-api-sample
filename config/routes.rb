require 'api_version_constraint'

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json }, constraints: { subdomain: false }, path: '/'  do
    namespace :v1, constraints: ApiVersionConstraint.new(version: 1) do
      resources :universities
      resources :campuses
      resources :professors
      resources :disciplines
      resources :documentation
    end

    namespace :v2, constraints: ApiVersionConstraint.new(version: 2, default: true) do
      resources :universities do
        get :find_by_acronym, to: 'universities#find_by_acronym', on: :collection
      end
      resources :campuses do
        get :find_by_name, to: 'campuses#find_by_name', on: :collection
        get :find_by_city, to: 'campuses#find_by_city', on: :collection
      end
      resources :professors
      resources :disciplines
      resources :documentation
    end
  end
end
