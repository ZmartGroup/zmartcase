class Case < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :emails
  belongs_to :user

end