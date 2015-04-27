class Email < ActiveRecord::Base
  attr_accessible :from, :to, :date, :body, :case_id, :subject
  belongs_to :case
  belongs_to :type
  belongs_to :category
  
end