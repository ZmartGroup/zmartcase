class EmailAccount < ActiveRecord::Base
   attr_accessible :imap, :port, :enable_ssl, :user_name, :password
end
