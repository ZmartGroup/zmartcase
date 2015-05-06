class NotesController < ApplicationController
  def index
  end

  def show
    @case = Case.find(params[:id])
  end

  def edit
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(params[:note])
    @note.user = current_user
    @note.save
    redirect_to new_category_path
  end

end
