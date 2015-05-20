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

    it "Filter_all: All threads should work" do
    	temp_email1.case = temp_case
    	temp_email1.save
		email_queue = Queue.new
		email_queue.push(temp_email1)

    	feedback_cat = Category.new(name: "Feedback")
    	feedback_cat.key_words.push(KeyWord.new(word: "hejsan", point: '10'))
        #key_words_DB.push(KeyWord.new(word: "brygga", point: '10'))
        #key_words_DB.push(KeyWord.new(word: "trevlig", point: '10'))
        #key_words_DB.push(KeyWord.new(word: "hallå", point: '2'))

        feedback_cat.save

        FilterMailController.new.filter_all_emails()
        expect(Email.first.category).to eq(feedback_cat)
   	end

end
