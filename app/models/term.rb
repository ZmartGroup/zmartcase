class Term < ActiveRecord::Base
  attr_accessible :amount, :word

  validates_presence_of :word, :on => :create
  validates_presence_of :amount, :on => :create

end
