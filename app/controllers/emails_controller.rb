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
  end

  def update
  end

  def destroy
  end
end
