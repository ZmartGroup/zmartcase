class Priority < ActiveRecord::Base
  attr_accessible :name
  has_many :cases
end
