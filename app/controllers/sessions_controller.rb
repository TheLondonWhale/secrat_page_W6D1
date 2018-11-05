class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      puts user.first_name
      log_in user
      redirect_to user
    else
      puts "HELLO"
      flash[:alert] = "La combinaison email/mot de passe est invalide. Veuillez Réessayer."
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end



end
