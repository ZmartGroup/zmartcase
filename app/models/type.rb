class Type < ActiveRecord::Base
  attr_accessible :description
  has_many :emails

end
