class UsersController < ApplicationController
  def index
    if !current_user
      redirect_to login_path
    else
      @users = User.all
    end
  end

  def dashboard

  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])

    if @user.save
      redirect_to users_path, notice:  'User updated'
    else
      render action: 'edit'
    end
  end

  def fetch
    FetchFromAll.new.perform
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      if !current_user
        redirect_to login_path, :notice => "Signed up!"
      else
        redirect_to users_path, :notice => "New user created1"
      end
    else
      redirect_to signup_path, :notice => "Try again!"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end

end
