require 'net/imap'
require 'mail'

class TempStuff

  def generate_categories_w_keywords
    #uncat_cat = Category.new(name: "Uncategorized")
    #uncat_cat.save



    feedback_cat = Category.new(name: "Feedback")
    feedback_cat.key_words.push(KeyWord.new(word: "feedback", point: '10'))
    feedback_cat.key_words.push(KeyWord.new(word: "tycker", point: '4'))
    feedback_cat.key_words.push(KeyWord.new(word: "bra", point: '2'))
    feedback_cat.key_words.push(KeyWord.new(word: "dåligt", point: '2'))
    feedback_cat.key_words.push(KeyWord.new(word: "förbättring", point: '8'))

    #feedback_cat.accounts.push(EmailAccount.new(email_address: "feedback@baraspara.se")
    feedback_cat.save
=begin
    avregistera_cat = Category.new(name: "Avregistrera")
    avregistera_cat.key_words.push(KeyWord.new(word: "avregistrera", point: '10'))
    avregistera_cat.key_words.push(KeyWord.new(word: "sluta", point: '8'))
    avregistera_cat.key_words.push(KeyWord.new(word: "missnöjd", point: '6'))
    avregistera_cat.key_words.push(KeyWord.new(word: "dåligt", point: '2'))
    avregistera_cat.key_words.push(KeyWord.new(word: "avsluta", point: '9'))

    feedback_cat.accounts.push(EmailAccount.new(email_address: "avregistrera@baraspara.se")
    avregistera_cat.save

=end

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

=begin
	def self.create_email_acc
		EmailAccount.create(imap: "imap.gmail.com", port: "993", enable_ssl: true, user_name: "barasparaprojtest@gmail.com", password: "Kth2015!")
	end

  def self.getMail
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


	def self.zip
    email_account = EmailAccount.new(imap: "imap.gmail.com", port: "993", enable_ssl: true, user_name: "barasparaprojtest@gmail.com", password: "Kth2015!")
    imap = Net::IMAP.new(email_account.imap, {:port => email_account.port, :ssl => email_account.enable_ssl})
    imap.login(email_account.user_name, email_account.password)
    imap.select('INBOX')
    imap.search(["UNSEEN"]).each do |message_id|
     return msg = imap.fetch(message_id, 'RFC822')[0].attr['RFC822']
      #mail = Mail.new(msg)
      #case_id = 15
      #  Email.create(case_id: case_id, date: mail.date,
      #  to: email_account.user_name, from: mail.from[0].to_s,
      #  raw: getA(msg),
      #  subject: mail.subject, body: mail.text_part.body.to_s)
      #imap.store(message_id, '+FLAGS', [:Seen])
    end
  end

  def self.create_file(msg)
    file = StringIO.new(ActiveSupport::Gzip.compress(msg))
    file.class.class_eval { attr_accessor :original_filename, :content_type }
    file.original_filename = 'rawMail.gzip'
    file.content_type = 'application/x-gzip'
    return file
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

  def self.dezip(email)
    uploader = ZmartUploader.new
    asd = uploader.retrieve_from_store!(email.raw)
    puts asd
    mail = Mail.new(ActiveSupport::Gzip.decompress(asd))
    puts "Subject is: " + mail.subject
  end






  def self.zip2
    email_account = EmailAccount.new(imap: "imap.gmail.com", port: "993", enable_ssl: true, user_name: "barasparaprojtest@gmail.com", password: "Kth2015!")
    imap = Net::IMAP.new(email_account.imap, {:port => email_account.port, :ssl => email_account.enable_ssl})
    imap.login(email_account.user_name, email_account.password)
    imap.select('INBOX')
    imap.search(["UNSEEN"]).each do |message_id|
      msg = imap.fetch(message_id, 'RFC822')[0].attr['RFC822']
      mail = Mail.new(msg)
      case_id = 15
      e = Email.create(case_id: case_id, date: mail.date,
       to: email_account.user_name, from: mail.from[0].to_s,
       raw: stuff(mail),
        subject: mail.subject, body: mail.text_part.body.to_s)
      imap.store(message_id, '+FLAGS', [:Seen])
    end
  end

  def self.stuff(mail)
    attachment = mail.attachments[0]
    file = StringIO.new(attachment.decoded)
    file.class.class_eval { attr_accessor :original_filename, :content_type }
    file.original_filename = attachment.filename
    file.content_type = attachment.mime_type
    return file
  end

















	def self.test3(mail)
    mail.attachments.each do |attachment|
      begin
        File.open("/home/olsom/zmartcase/" + attachment.filename, "w+b") {|f| f.write attachment.body.decoded}
      rescue => e
        puts "Unable to save data for #{attachment.filename} because #{e.message}"
      end
    end
  end
=end
end