class Api::V2::CampusesController < ApplicationController
  before_action :set_campus, only: [:show, :update, :destroy]

  def index
    campuses = fetch_campuses
    render json: campuses, status: 200
  end

  def show
    begin
      campus = Campus.find(params[:id])
      render json: campus, status: 200
    rescue
      head 404
    end
  end

  def create
    campus = Campus.new(campus_params)

    if campus.save
      render json: campus, status: 201
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    if @campus
      if @campus.update_attributes(campus_params)
        render json: @campus, status: 200
      else
        render json: { errors: @campus.errors }, status: 422
      end
    else
      render json: { errors: campus_params.errors }, status: 404
    end
  end

  def destroy
    render(nothing: true, status: 204) if @campus.destroy
  end

  def find_by_name
    campus = Campus.find_by(name: campus_params[:name])

    if campus.present?
      render json: campus, status: 200
    else
      head 404
    end
  end

  def find_by_city
    campuses = Campus.where(city: campus_params[:city])

    if campuses.present?
      render json: campuses, status: 200
    else
      head 404
    end
  end

  private

  def campus_params
    params.require(:campus).permit(:name, :city)
  end

  def set_campus
    begin
      @campus = Campus.find(params[:id])
    rescue
      head 404
    end
  end

  def fetch_campuses
    campuses = $redis.get('campuses')

    if campuses.nil? or !campuses.is_a? Array
      campuses = Campus.all.to_json
      $redis.set('campuses', campuses)
      $redis.expire('campuses', 5.hours.to_i)
    end

    JSON.load campuses
  end
end
