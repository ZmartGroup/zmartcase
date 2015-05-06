class Note < ActiveRecord::Base
  attr_accessible :body, :subject

  belongs_to :case
  belongs_to :user
end
