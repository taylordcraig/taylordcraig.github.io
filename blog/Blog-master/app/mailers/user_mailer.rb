class UserMailer < ApplicationMailer

  def password_reset(user)
    @user = user
    if @user && @user.email
      mail to: user.email, subject: "Password Reset"
    end
  end

end
