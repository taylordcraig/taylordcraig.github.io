class PasswordResetsController < ApplicationController

  def create
    user = User.find_by_email params[:email]
    user.send_password_reset
    UserMailer.password_reset(user).deliver_now
    redirect_to root_path,
    notice: 'Check your email for password reset instructions'
  end

  def edit
    @user = User.find_by_password_reset_token params[:id]
  end

  def update
    @user = User.find params[:id]
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, alert: 'Password reset expired!'
    elsif @user.update_attributes user_params
      redirect_to root_path, notice: 'Password reset!'
    else
      render :edit
    end
  end

  private

  def user_params
    user_params = params.require(:user).permit([:password,
                                                :password_confirmation])
  end
end
