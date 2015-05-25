class KeyWord < ActiveRecord::Base
  attr_accessible :point, :word, :category_id
  belongs_to :category
end
