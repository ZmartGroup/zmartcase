class ZmartMailer < ActionMailer::Base
  	def self.fetchAll
		emails = Array.new
		imap = Net::IMAP.new('imap.gmail.com', {:port => '993', :ssl => true})
		imap.login('barasparaprojtest@gmail.com', 'Kth2015!')
		imap.select('INBOX')
		imap.search(["ALL"]).reverse_each do |message_id|
			imap.store(message_id, '+FLAGS', [:Seen])
			msg = imap.fetch(message_id, 'RFC822')[0].attr['RFC822']
			mail = Mail.new(msg)

			ste = Email.new(date: mail.date, to: mail.to, from: mail.from, subject: mail.subject, message: mail.body)

			emails.push ste
		end
		imap.logout()
		imap.disconnect() 	
		return emails
	end

	def self.fetchNew
		emails = Array.new
		imap = Net::IMAP.new('imap.gmail.com', {:port => '993', :ssl => true})
		imap.login('barasparaprojtest@gmail.com', 'Kth2015!')
		imap.select('INBOX')
		imap.search(["UNSEEN"]).reverse_each do |message_id|
			imap.store(message_id, '+FLAGS', [:Seen])
			msg = imap.fetch(message_id, 'RFC822')[0].attr['RFC822']
			mail = Mail.new(msg)
			ste = Email.new(date: mail.date, to: mail.to, from: mail.from, subject: mail.subject, message: mail.body)
			emails.push ste
		end
		imap.logout()
		imap.disconnect() 
		return emails
	end
end
