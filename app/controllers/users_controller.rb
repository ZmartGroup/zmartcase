class UsersController < ApplicationController
  def index
    @category = Category.all
  end
end
