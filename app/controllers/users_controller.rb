class UsersController < ApplicationController

before_action :set_user, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path
    else
      render 'new'
    end
  end


  def show
  end

  def edit
  end

  def update
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end

  def destroy
    @user.destroy
    redirect_to root_path
  end

  def index
    if logged_in?
      @user = User.all.order("last_name ASC")
    else
      redirect_to login_path
    end
  end

private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

end
