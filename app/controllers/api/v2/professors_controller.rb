class Api::V2::ProfessorsController < ApplicationController
  before_action :set_professor, only: [:show, :update, :destroy]

  def index
    professors = fetch_professors
    render json: professors, status: 200
  end

  def show
    begin
      professor = Professor.find(params[:id])
      render json: professor, status: 200
    rescue
      head 404
    end
  end

  def create
    professor = Professor.new(professor_params)

    if professor.save
      render json: professor, status: 201
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    if @professor
      if @professor.update_attributes(professor_params)
        render json: @professor, status: 200
      else
        render json: { errors: @professor.errors }, status: 422
      end
    else
      render json: { errors: professor_params.errors }, status: 404
    end
  end

  def destroy
    render(nothing: true, status: 204) if @professor.destroy
  end

  def find_by_name
    professor = Professor.find_by(name: professor_params[:name])

    if professor.present?
      render json: professor, status: 200
    else
      head 404
    end
  end

  def find_by_university_name
    professors = Professor.joins(:university).where("LOWER(universities.name) LIKE LOWER(?)", "%#{professor_university_params[:university_name].downcase}%")

    if professors.present?
      render json: professors, status: 200
    else
      head 404
    end
  end

  def find_by_university_acronym
    professors = Professor.joins(:university).where("LOWER(universities.acronym) LIKE LOWER(?)", "%#{professor_university_params[:university_acronym].downcase}%")

    if professors.present?
      render json: professors, status: 200
    else
      head 404
    end
  end

  def find_by_formation_area
    professors = Professor.where("formation_area LIKE LOWER(?)", "%#{professor_params[:formation_area].downcase}%")

    if professors.present?
      render json: professors, status: 200
    else
      head 404
    end
  end

  private

  def professor_params
    params.require(:professor).permit(:name, :city, :formation_area)
  end

  def professor_university_params
    params.permit(:university_name, :university_acronym)
  end

  def set_professor
    begin
      @professor = Professor.find(params[:id])
    rescue
      head 404
    end
  end

  def fetch_professors
    professors = $redis.get('professors')

    if professors.nil? or !professors.is_a? Array
      professors = Professor.all.to_json
      $redis.set('professors', professors)
      $redis.expire('professors', 5.hours.to_i)
    end

    JSON.load professors
  end
end
