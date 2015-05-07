class EmailAccount < ActiveRecord::Base
   attr_accessible :imap, :port, :enable_ssl, :user_name, :password, :email_address

   belongs_to :category
end
