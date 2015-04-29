class Email < ActiveRecord::Base
  belongs_to :case
  belongs_to :type
  attr_accessible :from, :to, :date, :body, :case_id, :subject, :category_id
end