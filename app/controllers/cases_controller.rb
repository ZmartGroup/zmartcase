class CasesController < ApplicationController
  def index
  end

  def new

  end

  def create

  end

  def show
    @category = Category.find(params[:category_id])
    @cases = @category.cases
    @case = @category.cases.find(params[:id])
    @communications = @case.emails
    @communications += @case.notes
    @communications = @communications.sort_by(&:created_at).reverse

    @email = Email.new
    @note = Note.new
  end
end
