require 'api_version_constraint'

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json }, constraints: { subdomain: false }, path: '/'  do
    namespace :v1, constraints: ApiVersionConstraint.new(version: 1) do
      resources :universities
      resources :campuses
      resources :professors
      resources :disciplines
    end

    namespace :v2, constraints: ApiVersionConstraint.new(version: 2, default: true) do
      resources :universities do
        get :find_by_acronym, to: 'universities#find_by_acronym', on: :collection
      end
      resources :campuses do
        get :find_by_name, to: 'campuses#find_by_name', on: :collection
        get :find_by_city, to: 'campuses#find_by_city', on: :collection
      end
      resources :professors do
        get :find_by_name, to: 'professors#find_by_name', on: :collection
        get :find_by_university_name, to: 'professors#find_by_university_name', on: :collection
        get :find_by_university_acronym, to: 'professors#find_by_university_acronym', on: :collection
        get :find_by_formation_area, to: 'professors#find_by_formation_area', on: :collection
      end
      resources :disciplines do
        get :find_by_name, to: 'disciplines#find_by_name', on: :collection
        get :find_by_description, to: 'disciplines#find_by_description', on: :collection
        get :find_by_professor_name, to: 'disciplines#find_by_professor_name', on: :collection
      end
    end
  end
end
