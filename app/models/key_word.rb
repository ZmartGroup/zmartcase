class KeyWord < ActiveRecord::Base
  attr_accessible :point, :word
  belongs_to :category
end
