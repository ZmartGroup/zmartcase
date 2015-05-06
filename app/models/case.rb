class Case < ActiveRecord::Base
  attr_accessible :created_at
  has_many :emails
  has_many :notes
  belongs_to :user
  belongs_to :category

end
