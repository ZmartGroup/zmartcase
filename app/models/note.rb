class Note < ActiveRecord::Base
  attr_accessible :body, :subject, :case_id

  belongs_to :case
  belongs_to :user
end
