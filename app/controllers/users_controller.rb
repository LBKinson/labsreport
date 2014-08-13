class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)

  	if @user.save

  		session[:user_id] = @user.user_id
  		flash[:info] = "You signed up successfully, happy reporting!"
  		redirect_to '/report'
  	else
  		flash[:error] = @user.errors.full_messages.to_sentence
  		render :new
  	end
  end

private

	def user_params
		params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
	end

end
