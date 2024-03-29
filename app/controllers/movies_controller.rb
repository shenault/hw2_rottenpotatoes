class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_all_ratings
    
    if ((params[:sort] == nil && session[:sort] != nil) || (params[:ratings] == nil && session[:ratings] != nil))
      redirect_sort = params[:sort] != nil ? params[:sort] : session[:sort]
      redirect_ratings = params[:ratings] != nil ? params[:ratings] : session[:ratings]
      redirect_to  movies_path({:sort => redirect_sort, :ratings => redirect_ratings})
    end
    
    session[:sort] = params[:sort]
    session[:ratings] = params[:ratings]
    
    @ratings = params[:ratings]
    @sorted_by = params[:sort]
    
    if (params[:ratings] == nil)
      @movies = Movie.find(:all, :order => @sorted_by)
    else
      @movies = Movie.find(:all, :order => @sorted_by, :conditions => {:rating => params[:ratings].keys})
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
