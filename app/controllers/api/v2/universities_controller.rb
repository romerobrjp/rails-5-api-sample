class Api::V2::UniversitiesController < ApplicationController
  before_action :set_university, only: [:show, :update, :destroy]

  def index
    universities = fetch_universities
    render json: universities, status: 200
  end

  def show
    begin
      university = University.find(params[:id])
      render json: university, status: 200
    rescue
      head 404
    end
  end

  def create
    university = University.new(university_params)

    if university.save
      render json: university, status: 201
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    if @university
      if @university.update_attributes(university_params)
        render json: @university, status: 200
      else
        render json: { errors: @university.errors }, status: 422
      end
    else
      render json: { errors: university_params.errors }, status: 404
    end
  end

  def destroy
    render(nothing: true, status: 204) if @university.destroy
  end

  private

  def university_params
    params.require(:university).permit(:name, :acronym, :state)
  end

  def set_university
    begin
      @university = University.find(params[:id])
    rescue
      head 404
    end
  end

  def fetch_universities
    universities = $redis.get('universities')

    if universities.nil? or !universities.is_a? Array
      universities = University.all.to_json
      $redis.set('universities', universities)
      $redis.expire('universities', 5.hours.to_i)
    end

    JSON.load universities
  end
end
