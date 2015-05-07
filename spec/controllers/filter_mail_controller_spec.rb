require 'rails_helper'

describe FilterMailController do

	it "filter_all_emails: Should place all emails in a category and assign it a case" do
		to_email_address = "feedback@baraspara.se"
		tempEmail1 = Email.new(subject: "Hejsan", to: to_email_address,
			 from: "hej@hejsan.se", body: "trappa, Min trappa är trevlig")

		tempEmail2 = Email.new(subject: "Trappa", to: "info@baraspara.se",
			 from: "hej@hejsan.se", body: "trappa, Min trappa är trevlig")


		#FilterEmail.new.create_new_case(tempEmail)
		accountDB = Array.new
		tempAccount = EmailAccount.new(email_address: to_email_address)
		accountDB.push(tempAccount)


		keyWordsDB = Array.new
		keyWordsDB.push(KeyWord.new(word: "hejsan", point: "10"))
		keyWordsDB.push(KeyWord.new(word: "pelle", point: "10"))
		keyWordsDB.push(KeyWord.new(word: "skorsten", point: "10"))


		feedbackCat = Category.new(name: "Feedback")
		feedbackCat.email_accounts = accountDB
		feedbackCat.key_words = keyWordsDB

		keyWordsDB2 = Array.new
		keyWordsDB2.push(KeyWord.new(word: "falt", point: "4"))
		keyWordsDB2.push(KeyWord.new(word: "trappa", point: "8"))
		keyWordsDB2.push(KeyWord.new(word: "skorsten", point: "1"))
		keyWordsDB2.push(KeyWord.new(word: "trevlig", point: "1"))
		trappaCat = Category.new(name: "trappa kategori")

		trappaCat.key_words = keyWordsDB2

		FilterMailController.new.filter_all_caseless_emails
		#FilterEmail.new.execute_filter_threads(queue,2)
		expect(tempEmail1.category).equal? feedbackCat
		expect(tempEmail2.category).equal? trappaCat 


	end
end