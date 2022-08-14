class BooksController < ApplicationController

   before_action :authenticate_user!
   before_action :current_user, only: [:edit, :update, :destroy]

   def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new

    @book_detail = Book.find(params[:id])
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book_detail.id)
      current_user.view_counts.create(book_id: @book_detail.id)
    end
   end

   def index
     @books = Book.all
     @book = Book.new
     @user = current_user
     @book_comment = BookComment.new
     @books = Book.includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}

     @book_detail = current_user
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book_detail.id)
      current_user.view_counts.create(book_id: @book_detail.id)
    end
   end


   def create
      @book = Book.new(book_params)
      @book.user_id = current_user.id
      if @book.save
        redirect_to book_path(@book), notice: "You have created book successfully."
      else
        @books = Book.all
        render 'index'
      end
   end

   def edit
     @book = Book.find(params[:id])
   end

   def update
      @book = Book.find(params[:id])
      if @book.update(book_params)
        redirect_to book_path(@book), notice: "You have updated book successfully."
      else
        render "edit"
      end
   end

   def destroy
      @book = Book.find(params[:id])
      @book.destroy
      redirect_to books_path
   end

   private

   def book_params
     params.require(:book).permit(:title, :body)
   end

   def ensure_correct_user
      @book = Book.find(params[:id])
      unless @book.user == current_user
        redirect_to books_path
      end
   end
end