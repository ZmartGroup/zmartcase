class Email < ActiveRecord::Base

  attr_accessible :from, :to, :date, :body, :case_id, :subject, :category_id

  belongs_to :case
  belongs_to :type
  belongs_to :category

  #Creates a new mail

  #validates :to, presence: true
  #validates :from, presence: true


end