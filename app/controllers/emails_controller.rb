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

    def create

    #render plain: params[:email].inspect
    #@email = Email.new(params.require(:email).permit(:to, :from, :subject, :body))
    @email = Email.new(article_params)

    if @email.save
      redirect_to @email
    else
      render 'new'
    end
  end

  def index 
    @emails = Email.all
  end

  def new
    @email = Email.new
  end

  def update
  end

  def destroy
  end

    private
    def article_params
      params.permit(:to, :from, :subject, :body)
      #params.require(:email).permit(:to, :from, :subject, :body)
    end


end
