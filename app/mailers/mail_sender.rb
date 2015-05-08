require 'net/imap'
require 'mail'

class MailSender < ActionMailer::Base
	default from: "barasparaprojtest@gmail.com"

	def create_email(email)
		@email = email	
		sub = @email.subject
		mail(to: @email.to, subject: sub)
	end
end
