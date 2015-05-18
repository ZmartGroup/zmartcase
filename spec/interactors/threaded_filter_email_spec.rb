# encoding: UTF-8

require 'rails_helper'
require 'thread'

describe ThreadedFilterEmail do

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

    it "SeperateWords should seperaate swedish characters correctly" do
        sentance = "Ån ligger långt härifrån. Hur tycker du att vi ska lösa det? Många har gått för att hämta vatten där!"
        sep_sentance =SeperateWords.new.seperate(sentance)
        #print sep_sentance, "\n\n"
        #sep_sentance.each do |word|
        #    print word, "\n\n"
        #end
    end
=begin
    it "filter thread: add correct categories and cases to both emails" do
        temp_email1.case = Case.new
        temp_email1.save

        temp_email2 = Email.new(subject: "Trappa", to: "info@baraspara.se",
             from: "hej@hejsan.se", body: "trappa, Min trappa är trevlig")
        temp_email2.case = Case.new
        temp_email2.save



        email_queue = Queue.new
        email_queue.push(temp_email1)
        email_queue.push(temp_email2)
        #email_queue.save




        account_DB.push(temp_account)

        key_words_DB.push(KeyWord.new(word: "hejsan", point: '10'))
        key_words_DB.push(KeyWord.new(word: "pelle", point: '10'))
        key_words_DB.push(KeyWord.new(word: "skorsten", point: '10'))

        feedback_cat.email_accounts = account_DB
        feedback_cat.key_words = key_words_DB
        feedback_cat.save

        key_words_DB2.push(KeyWord.new(word: "falt", point: '4'))
        key_words_DB2.push(KeyWord.new(word: "trappa", point: '8'))
        key_words_DB2.push(KeyWord.new(word: "skorsten", point: '1'))
        key_words_DB2.push(KeyWord.new(word: "trevlig", point: '1'))
        trappa_cat = Category.new(name: "trappa kategori")

        trappa_cat.key_words = key_words_DB2
        trappa_cat.save
        FilterEmail.new.filter_mail(temp_email1)
        FilterEmail.new.filter_mail(temp_email2)
        expect(temp_email1.category).to eq(feedback_cat)
        expect(temp_email2.category).to eq(trappa_cat)
        expect(feedback_cat.cases.last).to eq(temp_email1.case)
        expect(trappa_cat.cases.last).to eq(temp_email2.case)
    end

	it "execute_filter_threads: should add correct categories to both emails in queue" do
        temp_email1.case = Case.new
        #temp_email1.subject = "thread test hejsan"
        temp_email1.save

        temp_email2 = Email.new(subject: "Thread Trappa", to: "info@baraspara.se",
             from: "hej@hejsan.se", body: "trappa, Min trappa är trevlig")
        temp_email2.case = Case.new
        temp_email2.save

        email_queue = Queue.new
        email_queue.push(temp_email1)
        email_queue.push(temp_email2)
        #email_queue.save

        account_DB.push(temp_account)

        key_words_DB.push(KeyWord.new(word: "hejsan", point: '10'))
        key_words_DB.push(KeyWord.new(word: "pelle", point: '10'))
        key_words_DB.push(KeyWord.new(word: "skorsten", point: '10'))

        feedback_cat.email_accounts = account_DB
        feedback_cat.key_words = key_words_DB
        feedback_cat.save

        key_words_DB2.push(KeyWord.new(word: "falt", point: '4'))
        key_words_DB2.push(KeyWord.new(word: "trappa", point: '8'))
        key_words_DB2.push(KeyWord.new(word: "skorsten", point: '1'))
        key_words_DB2.push(KeyWord.new(word: "trevlig", point: '1'))
        trappa_cat = Category.new(name: "trappa kategori")

        trappa_cat.key_words = key_words_DB2
        trappa_cat.save
        ThreadedFilterEmail.new.execute_filter_threads(email_queue,1)

        expect(temp_email1.category).to eq(feedback_cat)

        expect(temp_email2.category).to eq(trappa_cat)

        expect(feedback_cat.cases.last).to eq(temp_email1.case)
        expect(trappa_cat.cases.last).to eq(temp_email2.case)
    end
=end
end