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
#    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    redirect=false
    if params[:sort_para]
      @sort_para=params[:sort_para]
      session[:sort_para]=params[:sort_para]
    elsif session[:sort_para]
     @sort_para=session[:sort_para]
     redirect= true
    else
      @sort_para=nil
    end
    if params[:commit]=="Refresh" and params[:ratings].nil?
      @ratings=nil
      session[:ratings]=nil
    elsif params[:ratings]
      @ratings=params[:ratings]
      session[:ratings]=params[:ratings]
    elsif session[:ratings]
      @ratings = session[:ratings]
      redirect=true
    else
      @ratings=nil
    end
    
    if redirect
      flash.keep
      redirect_to movies_path :sort_para=>@sort_para, :ratings=>@ratings
    end
    
    @sort_para=params[:sort_para]
    @ratings = params[:ratings]
    if @ratings and @sort_para
      @movies =Movie.where(:rating=>@ratings.keys).order(@sort_para)
    elsif @ratings
      @movies =Movie.where(:rating=>@ratings.keys)
    elsif @sort_para
      @movies = Movie.order(@sort_para)
    else
      @movies=Movie.all
    end
    if !@ratings
      @ratings=Hash.new
    end
=begin
    @movies = Movie.all
    if params[:ratings]
      @movies =Movie.where(:rating=>params[:ratings].keys).order(params[:sort_para])
    end
    @sort_column = params[:sort_para]
    @all_ratings = Movie.all_ratings
    @set_ratings=params[:ratings]
    if !@set_ratings
      @set_ratings=Hash.new
    end
 #     @movies = Movie.all.order(params[:sort_para])
#      @sort_column=params[:sort_para]
=end
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
  def find_class(header)
    params[:sort] == header ? 'hilite' : nil
  end
  helper_method :find_class
end

