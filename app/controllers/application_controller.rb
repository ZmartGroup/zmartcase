class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_categories

  def set_categories
    @categories = Category.all
  end
end
