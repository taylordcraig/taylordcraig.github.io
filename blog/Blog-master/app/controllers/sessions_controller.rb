class SessionsController < ApplicationController

  def new
  end

  def create
    session[:login_attempt] ||= 0
    user = User.find_by_email params[:email].downcase
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:login_attempt] = 0
      redirect_to root_path, notice: 'Signed in'
    elsif session[:login_attempt] >= 5
      redirect_to new_password_reset_path, alert: 'Too many failed attempts'
    else
      redirect_to new_session_path, alert: 'Wrong email or password'
      session[:login_attempt] += 1
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Signed out'
  end

end
