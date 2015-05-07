class PrioritiesController < ApplicationController
  def index
    @prios = Priority.all
  end

  def show
  end

  def edit
  end

  def update
  end

  def new
    @prio = Priority.new
  end

  def create
    @prio = Priority.new(params[:priority])

    if @prio.save
      redirect_to priorities_path, notice: "Priority Created"
    else
      redirect_to priorities_path, alert: "Priority not created"
    end
  end

end
