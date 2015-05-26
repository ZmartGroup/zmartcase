class EmailAccountsController < ApplicationController
  def index
  	@email_accounts = EmailAccount.all
  end

  def edit
  	@email_account = EmailAccount.find(params[:id])
  end

  def new
  	@email_account = EmailAccount.new
  	@categories = Category.all
  end

  def create
  	@email_account = EmailAccount.new(params[:email_account])
    @email_account.save

    redirect_to email_accounts_path

  end

  def update
  	@email_account = EmailAccount.find(params[:id])
    @email_account.update_attributes(params[:email_account])

    if @email_account.save
      redirect_to(:back)
    else
      render action: 'edit'
    end
  end

  def destroy
  	@email_account = EmailAccount.find(params[:id])
    @email_account.destroy
    #redirect_to root_path
    redirect_to(:back)
  end

end
