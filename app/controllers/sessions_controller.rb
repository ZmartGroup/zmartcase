class SessionsController < ApplicationController
  def new
  end

  def create
    user = login(params[:email], params[:password])
    if user
      redirect_to root_path, :notice => "Logged in"
    else
      redirect_to login_path, :notice => "Email or password was incorrect!"
    end
  end

  def destroy
    logout
    redirect_to login_path, :notice => "Logged out!"
  end
end
