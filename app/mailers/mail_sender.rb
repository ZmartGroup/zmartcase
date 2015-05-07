require 'net/imap'
require 'mail'

class MailSender < ActionMailer::Base
	default from: "barasparaprojtest@gmail.com"

	def create_email(email)
		@email = email
		sub = @email.subject + " [CaseID:<" + @email.case_id.to_s + ">]"
		mail(to: @email.to, subject: sub)
	end
end
