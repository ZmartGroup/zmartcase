class Email < ActiveRecord::Base

	attr_accessible :from, :to, :date, :subject, :case_id, :body

  belongs_to :case
  belongs_to :type
  belongs_to :category
  

   #Creates a new mail

  #validates :to, presence: true
  #validates :from, presence: true


end

