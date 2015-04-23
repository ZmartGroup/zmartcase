class Email < ActiveRecord::Base
  attr_accessible :body, :case_id, :subject
  belongs_to :case
  belongs_to :type
  belongs_to :category

end
