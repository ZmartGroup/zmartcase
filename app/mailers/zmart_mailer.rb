require 'net/imap'
require 'mail'

class ZmartMailer < ActionMailer::Base
	default from: "barasparaprojtest@gmail.com"

	def create_email(email)
		@email = email		
		mail(to: @email.to, subject: @email.subject)
	end

	def self.fetch_all_from_all
		Email.delete_all
		emails = Array.new
		EmailAccount.all.each do |acc|
			emails.push(*fetch_all_from_one(acc))
		end
		return emails
	end

	def self.fetch_new_from_all
		emails = Array.new
		EmailAccount.all.each do |acc|
			emails.push(*fetch_new_from_one(acc))
		end
		return emails
	end

	def self.fetch_all_from_one(email_account)
		emails = Array.new
		imap = Net::IMAP.new(email_account.imap, {:port => email_account.port, :ssl => email_account.enable_ssl})
		imap.login(email_account.user_name, email_account.password)
		imap.select('INBOX')
		imap.search(["ALL"]).reverse_each do |message_id|
			imap.store(message_id, '+FLAGS', [:Seen])
			msg = imap.fetch(message_id, 'RFC822')[0].attr['RFC822']
			mail = Mail.new(msg)
			ste = Email.new(date: mail.date, to: mail.to, from: mail.from, subject: mail.subject, body: mail.body)
			ste.save
			emails.push ste
		end
		imap.logout()
		imap.disconnect()
		return emails
	end

	def self.fetch_new_from_one(email_account)
		emails = Array.new
		imap = Net::IMAP.new(email_account.imap, {:port => email_account.port, :ssl => email_account.enable_ssl})
		imap.login(email_account.user_name, email_account.password)
		imap.select('INBOX')
		imap.search(["UNSEEN"]).reverse_each do |message_id|
			imap.store(message_id, '+FLAGS', [:Seen])
			msg = imap.fetch(message_id, 'RFC822')[0].attr['RFC822']
			mail = Mail.new(msg)
			ste = Email.new(date: mail.date, to: mail.to, from: mail.from, subject: mail.subject, body: mail.body)
			ste.save
			emails.push ste
		end
		imap.logout()
		imap.disconnect()
		return emails
	end

	def self.fetch_from_one(email_account, only_new: false)
    inbox_type = only_new ? "UNSEEN" : "ALL"
		emails = Array.new
		imap = Net::IMAP.new(email_account.imap, {:port => email_account.port, :ssl => email_account.enable_ssl})
		imap.login(email_account.user_name, email_account.password)
		imap.select('INBOX')
		imap.search([inbox_type]).reverse_each do |message_id|
			imap.store(message_id, '+FLAGS', [:Seen])
			msg = imap.fetch(message_id, 'RFC822')[0].attr['RFC822']
			mail = Mail.new(msg)
			ste = Email.new(date: mail.date, to: mail.to, from: mail.from, subject: mail.subject, body: mail.body)
			ste.save
			emails.push ste
		end
		imap.logout()
		imap.disconnect()
		return emails
	end

end
