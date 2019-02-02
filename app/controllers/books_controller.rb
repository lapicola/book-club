class BooksController < ApplicationController

  def index
    case params[:sort]
      when 'page_count' then @books = Book.by_page_count(params[:order])
      when 'year' then @books = Book.by_year(params[:order])
      else @books = Book.all
    end
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
    @authors = Author.all
  end

  def create
    @book = Book.new(book_params)
    @book.authors = params[:book][:authors].split(",").map do |author|
      Author.find_or_create_by(name: author.titleize.strip)
    end
    if @book.save
      redirect_to book_path(@book)
    else
      @authors = Author.all
      render :new
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :page_count, :year, :cover_image, author_ids: [])
  end

end
