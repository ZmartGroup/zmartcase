class PrioritiesController < ApplicationController
  def index
    @prios = Priority.all
  end

  def show
  end

  def edit
    @prio = Priority.find(params[:id])
  end

  def update
    @prio = Priority.find(params[:id])
    @prio.update_attributes(params[:priority])

    if @prio.save
      redirect_to priorities_path, notice:  'Prio updated'
    else
      render action: 'edit'
    end
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

  def destroy
    @prio = Priority.find(params[:id])
    @prio.destroy
    redirect_to priorities_path
  end

end
