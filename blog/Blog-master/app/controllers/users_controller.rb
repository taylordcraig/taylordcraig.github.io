class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new find_params
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Thanks for signing up.'
    else
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
   @user = current_user
   if @user && @user.authenticate(user_params[:current_password])
     if @user.update find_params
       redirect_to home_path, notice: "Successfully updated"
     else
       render :edit
     end
   else
     flash.now[:alert] = "Wrong credentials. Please try again."
     render :edit
   end
 end

  def destroy
    @user = current_user
    session[:user_id] = nil
    @user.destroy
    redirect_to root_path, notice: 'User deleted'
  end

  def index
  end

  private

  def find_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
  end

end
