class Email < ActiveRecord::Base
  belongs_to :case
  belongs_to :type

end