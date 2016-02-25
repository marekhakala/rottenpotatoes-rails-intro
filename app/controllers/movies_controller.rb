class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirect = false
    @sort_order = nil
    @all_ratings = Movie.all_ratings

    redirect = true unless params[:ratings].nil? or params[:order_by].nil?
    session[:ratings] = params[:ratings].keys if is_param_set?(:ratings)
    session[:sort_by] = params[:sort_by] if is_param_set?(:sort_by)

    @movies = session[:ratings] ? Movie.where(rating: session[:ratings]) : Movie.all

    if session[:sort_by] == "title"
      @sort_order = { title: :asc }
    elsif session[:sort_by] == "date"
      @sort_order = { release_date: :asc }
    end

    if redirect
      ratings = {}

      session[:ratings].keys.each do |key|
        ratings[key] = 1
      end

      redirect_to order_by: session[:sort_by], ratings: ratings
    end

    @movies = @movies.order(@sort_order) unless @sort_order.nil?
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

  private
    def is_param_set? name
      params[name] and params[name] != session[name]
    end
end
