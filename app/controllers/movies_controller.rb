class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_all_ratings
    is_must_redirect = false
    
    if (params[:ratings] == nil)
      @ratings = session[:ratings]
      is_must_redirect = true
    else
      @ratings = params[:ratings]
      session[:ratings] = params[:ratings]
    end
    
    if (params[:sort] == nil)
      @sorted_by = session[:sort]
      is_must_redirect = true
    else
      @sorted_by = params[:sort]
      session[:sort] = params[:sort]
    end
    
    if (is_must_redirect)
      redirect_to movies_path({:sort => :release_date, :ratings => @ratings})
    end
    
    if (@ratings == nil)
      @movies = Movie.find(:all, :order => @sorted_by)
    else
      @movies = Movie.find(:all, :order => @sorted_by, :conditions => {:rating => @ratings.keys})
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
