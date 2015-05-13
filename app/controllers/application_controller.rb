class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_categories, :set_closed_cases

  def set_categories
    @categories = Category.all
  end

  def set_closed_cases
    @closed_cases = Case.where(closed: true)
  end
end
