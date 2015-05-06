require 'net/imap'
require 'mail'

class FetchFromOne
  def initialize(email_account, only_unseen = true)
    @email_account = email_account
    only_unseen ? @imap_search_for = "UNSEEN" : @imap_search_for = "ALL"
    create_imap
    imap_login
  end

  def perform
    if check_for_unread > 0
      imap_select_inbox
      imap_readmail
    end
  end

  #HELPER functions
  #Creates the imap
	def create_imap   
    @imap = Net::IMAP.new(@email_account.imap, {:port => @email_account.port, :ssl => @email_account.enable_ssl})
	end

  #Login into imap using the given account credentials
  def imap_login
    @imap.login(@email_account.user_name, @email_account.password)
  end

  #Mails are read from inbox
  def imap_select_inbox
    @imap.select('INBOX') 
  end

  def check_for_unread
    number = @imap.status("INBOX", [@imap_search_for])[@imap_search_for]
    return number
  end

  #Read the new mail, save in db
  def imap_readmail
    @imap.search([@imap_search_for]).each do |message_id|
      msg = @imap.fetch(message_id, 'RFC822')[0].attr['RFC822']
      mail = Mail.new(msg)
      case_id = get_case_id(mail)
      Email.create(case_id: case_id, date: mail.date, to: @email_account.user_name, from: mail.from[0].to_s, subject: mail.subject, body: mail.text_part.body.to_s)
      @imap.store(message_id, '+FLAGS', [:Seen])
    end
  end

  def get_case_id(mail)
    mail.subject.include?("[CaseID:") ? case_id =  mail.subject[/.*<([^>]*)/,1] : case_id = nil
    if case_id.nil?
     mail.text_part.body.to_s.include?("[CaseID:") ? case_id =  mail.text_part.body.to_s[/.*<([^>]*)/,1] : case_id = nil
    end
    return case_id
  end

  #logout from imap
  def imap_logout
    @imap.logout
    @imap.disconnect 
  end
end