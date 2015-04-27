class CasesController < ApplicationController
  def index
  end

  def new
  end

  def show
    @category = Category.find(params[:category_id])
    @cases = @category.cases
    @case = @category.cases.find(params[:id])
    @communications = @case.emails
  end
end
