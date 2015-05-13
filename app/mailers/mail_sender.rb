require 'net/imap'
require 'mail'

class MailSender < ActionMailer::Base
	default from: "barasparaprojtest@gmail.com"

	def create_email(email)
<<<<<<< HEAD
		@email = email
=======
		@email = email	
>>>>>>> 67691026f8b37308186295e456e6138a171cdd84
		sub = @email.subject
		mail(to: @email.to, subject: sub)
	end
end
