class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  before_action :logged_in_user, only: [:edit, :update, :destroy]


  def new
    @user = User.new
  end

  def show
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash.now[:success] = "Connexion réussie"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    if logged_in? && @current_user.id == @user.id
    else
      redirect_to root_path
      flash[:danger] = "Accès restreint: tu ne peux pas accéder à ces informations."
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id)
    else
      flash.now[:danger] = ""
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path
  end

  def index
    if logged_in?
    else
      flash[:danger] = "Cette page n'est accessible qu'aux membres connectés"
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

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Veuillez vous connectez pour accéder à cette page."
      redirect_to login_url
    end
  end

end
