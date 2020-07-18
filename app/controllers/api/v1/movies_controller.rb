class Api::V1::MoviesController < ApplicationController
  before_action :set_all_value, only: [:track_seats]
	def index
  	movies  = Movie.all
  	render json: {movies: movies},status: 200
  end

  def show
    movie = Movie.find(params[:id])
    render json: {movie: movie},status: 200
  end


  def create
    movie = Movie.new(movie_params)
    if movie.save
    	render json: {movie: movie},status: 200
    else
      render json: {movie: movie.errors.full_messages},status: 400
    end
  end


  def update
    movie = Movie.find(params[:id])
    if movie.update_attributes(movie_params)
    	render json: {movie: movie},status: 200
    else
      render json: {movie: movie.errors.full_messages},status: 400
    end
  end


  def track_seats
    seats_from_center = Movie.find_best_seat(@rows,@columns)
    avail_seats = Movie.seats(JSON.parse(@seats.to_json))
    response = Movie.get_best_seats(seats_from_center,avail_seats,@number_of_seats)
    
    render json: {response: response},status: 200
  end


  def set_all_value
    
     @venue = params[:venue]
     @seats = params[:seats]
     @rows = params[:venue][:layout][:rows].to_i
     @columns = params[:venue][:layout][:columns].to_i
     @number_of_seats = params[:number_of_seats].nil? ? 1 : params[:number_of_seats]
     if @rows > 10
      render json: {error: "row should be 10"},status: 400
     end
     if @seats.empty?
       render json: {error: "Please select at least one seat"},status: 400
     end
     
     if @number_of_seats.to_i > JSON.parse(@seats.to_json).length
      render json: {error: "Number of seats should be less or equal to selected seats"},status: 400
     end
  end

  private 
  def movie_params
  	params.require(:movie).permit(:title,:genre,:summary,:year,:imdb_url)
  end
end
