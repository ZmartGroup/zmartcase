class CasesController < ApplicationController
  def index
  end

  def new

  end

  def edit

  end

  def closed_show
    @cases = Case.where(closed: true)
    @case = Case.find(params[:id])

    @category = @case.category

    @communications = @case.emails
    @communications += @case.notes
    @communications = @communications.sort_by(&:created_at).reverse

  end

  def update
    @category = Category.find(params[:category_id])
    @case = Case.find(params[:id])
    if @case.update_attributes(params[:case])
      if @case.closed
        @case.update_attributes(closed_at: DateTime.now)
      end
      redirect_to category_case_path(@category,@case), notice: "Case is updated!"
    else
      redirect_to category_case_path(@category,@case), alert: "Case was not updated!"
    end
  end

  def create

  end

  def show
    @category = Category.find(params[:category_id])
    @cases = @category.cases.where(closed: [nil,false])
    @case = Case.find(params[:id])
    @users = User.all

    #to list all communications in @case
    @communications = @case.emails
    @communications += @case.notes
    @communications = @communications.sort_by(&:created_at).reverse

    #for creating new communications under @case
    @email = Email.new
    @note = Note.new
  end

end
