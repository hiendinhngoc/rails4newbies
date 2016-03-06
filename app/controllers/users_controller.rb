class UsersController < ApplicationController

  before_filter :save_login_state, :only => [:new, :create]

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		flash[:success] = "You signed up successfully"
      render "sessions/home"
  	else
      render "new"
  	end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :salt, :encrypted_password)
  end
end
