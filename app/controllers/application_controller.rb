class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_categories, :set_closed_cases, :set_user, :set_uncategorized

  def set_categories
    @categories = Category.all
  end

  def set_uncategorized
    @categories = Category.all
    @uncategorized = Email.where(:category_id => nil)
  end

  def set_closed_cases
    @closed_cases = Case.where(closed: true)
  end

  def set_user
    @user = current_user
  end

end
