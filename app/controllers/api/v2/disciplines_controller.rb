class Api::V2::DisciplinesController < ApplicationController
  before_action :set_discipline, only: [:show, :update, :destroy]

  def index
    disciplines = fetch_disciplines
    render json: disciplines, status: 200
  end

  def show
    begin
      discipline = Discipline.find(params[:id])
      render json: discipline, status: 200
    rescue
      head 404
    end
  end

  def create
    discipline = Discipline.new(discipline_params)

    if discipline.save
      render json: discipline, status: 201
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    if @discipline
      if @discipline.update_attributes(discipline_params)
        render json: @discipline, status: 200
      else
        render json: { errors: @discipline.errors }, status: 422
      end
    else
      render json: { errors: discipline_params.errors }, status: 404
    end
  end

  def destroy
    render(nothing: true, status: 204) if @discipline.destroy
  end

  def find_by_name
    discipline = Discipline.find_by(name: discipline_params[:name])

    if discipline.present?
      render json: discipline, status: 200
    else
      head 404
    end
  end

  def find_by_description
    disciplines = Discipline.where("LOWER(description) LIKE LOWER(?)", "%#{discipline_params[:description]}%")

    if disciplines.present?
      render json: disciplines, status: 200
    else
      head 404
    end
  end

  def find_by_professor_name
    disciplines = Discipline.joins(:professors).where("LOWER(professors.name) LIKE LOWER(?)", "%#{discipline_professor_params[:professor_name]}%")

    if disciplines.present?
      render json: disciplines, status: 200
    else
      head 404
    end
  end

  private

  def discipline_params
    params.require(:discipline).permit(:name, :description)
  end

  def discipline_professor_params
    params.permit(:professor_name)
  end

  def set_discipline
    begin
      @discipline = Discipline.find(params[:id])
    rescue
      head 404
    end
  end

  def fetch_disciplines
    disciplines = $redis.get('disciplines')

    if disciplines.nil? or !disciplines.is_a? Array
      disciplines = Discipline.all.to_json
      $redis.set('disciplines', disciplines)
      $redis.expire('disciplines', 5.hours.to_i)
    end

    JSON.load disciplines
  end
end
