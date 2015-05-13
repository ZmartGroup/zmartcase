# encoding: UTF-8
require 'rails_helper'

describe FilterMailController do
    let (:word) {"hejsan"}
    let (:temp_key_word) {KeyWord.new(word: word, point: '10')}
    let (:key_words_DB) {Array.new}
    let (:key_words_DB2) {Array.new}
    let (:words_DB) {Array.new}
    let (:temp_email1) {Email.new(subject: "Hejsan", to: "info@baraspara.se", from: "hej@hejsan.se",
            body: "hejsan, Min brygga ar trevlig")}
    let (:feedback_cat) {Category.new(name: "Feedback")}
    let (:fel_cat) {Category.new(name: "fel kategori")}
    let (:temp_case) {Case.new}
    let (:to_email_address) {"feedback@baraspara.se"}
    let (:account_DB) {Array.new}
    let (:temp_account) {EmailAccount.new(email_address: to_email_address)}

	it "filter_all_emails: Should place all emails in a category and assign it a case" do
		to_email_address = "feedback@baraspara.se"


		temp_email1 = Email.new(subject: "Hejsan", to: to_email_address,
			 from: "hej@hejsan.se", body: "trappa, Min trappa ar trevlig")

		temp_email2 = Email.new(subject: "Trappa", to: "info@baraspara.se",
			 from: "hej@hejsan.se", body: "trappa, Min trappa ar trevlig")


		accountDB = Array.new
		temp_account = EmailAccount.new(email_address: to_email_address)
		accountDB.push(temp_account)

		key_words_DB = Array.new
		key_words_DB.push(KeyWord.new(word: "hejsan", point: "10"))
		key_words_DB.push(KeyWord.new(word: "pelle", point: "10"))
		key_words_DB.push(KeyWord.new(word: "skorsten", point: "10"))

		feedback_cat = Category.new(name: "Feedback")
		feedback_cat.email_accounts = accountDB
		feedback_cat.key_words = key_words_DB

		key_words_DB2 = Array.new
		key_words_DB2.push(KeyWord.new(word: "falt", point: "4"))
		key_words_DB2.push(KeyWord.new(word: "trappa", point: "8"))
		key_words_DB2.push(KeyWord.new(word: "skorsten", point: "1"))
		key_words_DB2.push(KeyWord.new(word: "trevlig", point: "1"))
		trappa_cat = Category.new(name: "trappa kategori")

		trappa_cat.key_words = key_words_DB2

		FilterMailController.new.filter_all_caseless_emails
		expect(temp_email1.category).equal? feedback_cat
		expect(temp_email2.category).equal? trappa_cat 
	end
end
