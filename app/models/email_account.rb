class EmailAccount < ActiveRecord::Base
   attr_accessible :imap, :port, :enable_ssl, :user_name, :password, :email_address, :category_id

   belongs_to :category
end