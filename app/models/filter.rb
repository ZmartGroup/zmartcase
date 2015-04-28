class Filter < ActiveRecord::Base
  attr_accessible :categories, :name
  has_many :categories
end
