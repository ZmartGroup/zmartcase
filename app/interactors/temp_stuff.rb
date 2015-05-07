class TempStuff
	def self.create_email_acc
		EmailAccount.create(imap: "imap.gmail.com", port: "993", enable_ssl: true, user_name: "barasparaprojtest@gmail.com", password: "Kth2015!")
	end


 	
	def self.test2

		email_account = EmailAccount.new(imap: "imap.gmail.com", port: "993", enable_ssl: true, user_name: "barasparaprojtest@gmail.com", password: "Kth2015!")

		imap = Net::IMAP.new(email_account.imap, {:port => email_account.port, :ssl => email_account.enable_ssl})
		imap.login(email_account.user_name, email_account.password)
		imap.select('INBOX')
		imap.search(["ALL"]).reverse_each do |message_id|
			imap.store(message_id, '+FLAGS', [:Seen])
			msg = imap.fetch(message_id, 'RFC822')[0].attr['RFC822']
			mail = Mail.new(msg)
			

			return mail

			
		end
		
	end
end