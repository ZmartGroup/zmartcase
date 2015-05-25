class MailSenderJob
	include SuckerPunch::Job

	def perform(email, attach, current_user)
		ActiveRecord::Base.connection_pool.with_connection do
      email.is_sent = true
      if email.case_id.nil?
        temp_case = Case.new
        temp_case.user = current_user
        temp_case.category_id = email.category_id
        temp_case.save
        email.case = temp_case
      end
      unless email.subject.include?("[CaseID:")
        email.subject += " [CaseID:<" + email.case_id.to_s + ">]"
      end

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