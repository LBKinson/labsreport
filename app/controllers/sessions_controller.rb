class SessionsController < ApplicationController

  # Login form
  def new
  end

  # Check password and, if good, log them in
  def create
    @user = User.find_by_email(params[:email])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:info] = 'Welcome back!'
      redirect_to '/report'
    else
      flash[:error] = 'Email or password was incorrect.'
      render :new
    end
  end

  # Log them out
  def destroy
    session[:user_id] = nil
    redirect_to '/'
  end

end