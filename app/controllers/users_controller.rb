class UsersController < ApplicationController

   before_action :correct_user, only: [:edit, :update]

  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def index
    @user = current_user
    @users = User.all
    @book = Book.new
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path(@user.id)
    else
      render action: :edit
    end
  end

   private
  def user_params
    params.require(:user).permit(:name, :introduction, :image)
  end

  def correct_user
    @user = User.find(params[:id])
    @book = @user.books
    redirect_to(books_path) unless @user == current_user
  end
end
