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



	#Methods for testing purposes
	def remove_all_cases_and_categories_from_emails
		Email.all.each do |email|
			email.case = nil
			#email.category = nil
			email.save
			
		end
	end

	def generate_random_emails(num)
		require 'open-uri'
		until 0>num do
			#generate subject with 1 -5 words
			knum = rand(4) +1 
			email_subject = ""
			until 1 > knum do
				word = open('http://randomword.setgetgo.com/get.php').read.to_s
				word = word.chomp
				email_subject += word.to_s
				email_subject += " "
				knum -=1
			end
			

			#generate body with 40-70 words
			knum = rand(30) +40
			email_body = ""

			until 1 > knum do
				word = open('http://randomword.setgetgo.com/get.php').read.to_s
				word = word.chomp

				email_body += word.to_s
				email_body += " "
				knum -=1
			end
			logger.debug email_body + " \n"

			#generate from and to
			email_from = ""
			word = open('http://randomword.setgetgo.com/get.php').read.to_s
			word = word.chomp
			email_from += word 
			email_from += "@"
			word = open('http://randomword.setgetgo.com/get.php').read.to_s
			word = word.chomp
			email_from += word
			email_from +=".com"

			email_to = "info@baraspara.se"

			tempEmail = Email.new
			tempEmail.subject = email_subject
			tempEmail.body = email_body
			tempEmail.from = email_from
			tempEmail.to = email_to
			tempEmail.save
			num-=1
		end	
		#redirect_to filter_mail_index_path
	end


end	
