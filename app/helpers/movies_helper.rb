module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def sort_hyperlink(column)
    column2 = (column == "Movie Title")? "title":"release_date"
    dir = (column2 == sort_column && sort_dir == "asc")? "desc":"asc"
    ident = ""
    if column2 == "title"
      ident = "title_header"
    else
      ident = "release_date_header"
    end
    link_to "#{column.titleize}",{column: column, dir: dir}, :id => ident
  end
end
