class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @cases = @category.cases
  end

  def edit
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
    end
  end

  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, notice: 'Category was successfully created.' }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @category = Category.find(params[:id])
    @category.update_attributes(params[:category])

    if @category.save
      redirect_to root_path, notice:  'Name updated'
    else
      render action: 'edit'
    end
  end



  def destory
    #TODO
    #What happens with cases?
    #delete alla associated key words
  end
end
