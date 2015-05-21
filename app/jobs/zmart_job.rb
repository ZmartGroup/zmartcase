class ZmartJob
	include SuckerPunch::Job

	def perform(email, attach)
		ActiveRecord::Base.connection_pool.with_connection do
			mail = MailSender.create_email(email)
	    unless attach.nil?
	      attach.each do |attachment|
	        mail.attachments[attachment.original_filename] = File.read(attachment.path)
	      end
	    end
	    mail.deliver
      email.raw = MailCompressor.compress_mail(mail)
      email.save
		end
	end
end