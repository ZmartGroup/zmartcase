class UsersController < ApplicationController
  def index
    @category = Category.all
    @cases = Case.all
    @user = current_user
    @emails = Email.all
  end

  def fetch
    FetchFromAll.new(false).perform
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to login_path, :notice => "Signed up!"
    else
      redirect_to signup_path, :notice => "Try again!"
    end
  end

end
