class EmailsController < ApplicationController
  
  def index
  end

  def show
    @category = Category.find(params[:category_id])
    @emails = @category.emails
    @email = @category.emails.find(params[:id])
  end

  def edit
  end

  def new
    @email = Email.new
  end

  def create
    @email = Email.new(params[:email])
    @email.save
    MailSender.create_email(@email).deliver
    redirect_to new_category_path 
  end

  def update
  end

  def destroy
  end
end
