require 'net/imap'
require 'mail'

class TempStuff
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
end