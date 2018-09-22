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
    if session[:column]==nil or (session[:column] != sort_column and params[:column]!=nil)
      session[:column] = sort_column
    end
    if session[:dir]==nil or (session[:dir] != sort_dir and params[:dir]!=nil)
      session[:dir] = sort_dir
    end
    if session[:ratings].blank? or params[:commit]!=nil
      session[:ratings] = boxes_checked
    end
    
    @all_ratings = Movie.select("DISTINCT rating").map(&:rating)
    @checked = session[:ratings]
    if session[:dir] != ""
      if @checked.empty?
        @movies = Movie.order("#{session[:column]} #{session[:dir]}").all
      else
        @movies = Movie.order("#{session[:column]} #{session[:dir]}").select {|i| @checked.include?(i.rating)? true: false}
      end
      if session[:column] == "title"
        @val = "hilite"
        @val2 = ""
      else
        @val = ""
        @val2 = "hilite"
      end
    else
      if @checked.empty?
        @movies = Movie.all
      else 
        @movies = Movie.all.select{|i| @checked.include?(i.rating)? true: false}
      end
      @val = ""
      @val2 = ""
    end
  end
  
  private def boxes_checked
    if params[:ratings] == nil
      return []
    end
    return params[:ratings].keys
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
