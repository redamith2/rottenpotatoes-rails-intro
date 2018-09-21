class MoviesController < ApplicationController
  
  helper_method :sort_column, :sort_dir

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if sort_dir != ""
      @movies = Movie.order("#{sort_column} #{sort_dir}").all
      if sort_column == "title"
        @val = "hilite"
        @val2 = ""
      else
        @val = ""
        @val2 = "hilite"
      end
    else
      @movies = Movie.all
      @val = ""
      @val2 = ""
    end
  end
  
  def sort_column
    if params[:column] == "Movie Title"
      return "title"
    elsif params[:column] == "Release Date"
      return "release_date"
    else
      return "title"
    end
  end
  
  def sort_dir
    if params[:dir] == "asc"
      return "asc"
    elsif params[:dir] == "desc"
      return "desc"
    else
      return ""
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
