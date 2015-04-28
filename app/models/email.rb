class Email < ActiveRecord::Base



  belongs_to :case
  belongs_to :type
  belongs_to :category
  

   #Creates a new mail

  #validates :to, presence: true
  #validates :from, presence: true


end

