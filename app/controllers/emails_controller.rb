class EmailsController < ApplicationController

  def index
  end

  def show
    #@category = Category.find(params[:category_id])
    #@emails = @category.emails
    #@email = @category.emails.find(params[:id])
    @email = Email.find(params[:id])
  end

  def edit
  end

  def index
    @emails = Email.all
  end

  def new
    @email = Email.new

  end

  def create
    @email = Email.new(params[:email])
    @email.save
    #ZmartMailer.create_email(@email).deliver
    redirect_to new_category_path
  end

  def update
  end

  def destroy
  end



end
