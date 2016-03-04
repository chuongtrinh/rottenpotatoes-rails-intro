class MoviesController < ApplicationController

  def initialize
    @all_ratings = Movie.all_ratings
    super
  end
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @movies = Movie.order params[:sorting]
    @all_ratings = Movie.all_ratings
    
    if params[:ratings]
      @select_ratings = params[:ratings]
      session[:select_ratings] = @select_ratings# retrieve ratings selected from html
    else
      session[:select_ratings] = @all_ratings 
    end
    
    if session[:select_ratings]
      @movies = @movies.select{ |movie| session[:select_ratings].include? movie.rating }
    end
     
     
            
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
