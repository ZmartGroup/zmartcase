# encoding: UTF-8
require 'rails_helper'

describe FilterEmail do
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

    it "check_key_words: should return 10 with a keyWord = 10" do
        key_words_DB.push(temp_key_word)
        expect(FilterEmail.new.check_key_words(word,key_words_DB,false)).to be 10
    end

    it "check_key_words: should return 20 with a keyWord = 10 with subject = true" do
        key_words_DB.push(temp_key_word)
        expect(FilterEmail.new.check_key_words(word,key_words_DB,true)).to be 20
    end


    it "check_words: should return 20 with 2 matching words worth 10" do
        words_DB.push("hejsan"); words_DB.push("rasp"); words_DB.push("pelle"); words_DB.push("trappa")
        key_words_DB.push(KeyWord.new(word: "hejsan", point: '10'))
        key_words_DB.push(KeyWord.new(word: "trappa", point: '10'))
        key_words_DB.push(KeyWord.new(word: "skorsten", point: '10'))
        feedback_cat.key_words = key_words_DB

        expect(FilterEmail.new.check_words(feedback_cat.key_words, words_DB, false)).to be 20
    end

    it "attach_case_to_category: both case category and email category should be same" do
        temp_email1.case = temp_case
        temp_email1.save
        FilterEmail.new.attach_case_to_category(temp_email1,feedback_cat)

        expect(temp_email1.case).to eq(feedback_cat.cases.last)
    end

    it "attach_case_to_category: if email has case it should add that case to category" do
        temp_email1.case = temp_case
        temp_email1.save
        FilterEmail.new.attach_case_to_category(temp_email1,feedback_cat)
        expect(temp_email1.case).to eq(feedback_cat.cases.last)
    end

    it "check_subject_and_body: should get category = feedback" do
        temp_email1 = Email.new(subject: "Hejsan", to: "info@baraspara.se", from: "hej@hejsan.se",
            body: "hejsan, Min brygga har en trevlig")
        temp_email1.case = Case.new
        temp_email1.save

        key_words_DB.push(KeyWord.new(word: "hejsan", point: '10'))
        key_words_DB.push(KeyWord.new(word: "trappa", point: '10'))
        key_words_DB.push(KeyWord.new(word: "skorsten", point: '10'))

        key_words_DB2.push(KeyWord.new(word: "rymden", point: '10'))
        key_words_DB2.push(KeyWord.new(word: "operan", point: '10'))
        key_words_DB2.push(KeyWord.new(word: "info", point: '10'))

        feedback_cat.key_words = key_words_DB
        feedback_cat.save

        fel_cat.key_words = key_words_DB2
        fel_cat.save


        FilterEmail.new.check_subject_and_body(temp_email1)


        expect(FilterEmail.new.check_key_words(word,key_words_DB,false)).to be 10
        expect(FilterEmail.new.check_key_words(word,key_words_DB2,false)).to be 0


        expect(temp_email1.category).to eq(feedback_cat)
    end

    it "check_subject_and_body: email category should be same as case category" do
        temp_email1.case = temp_case
        temp_email1.save

        key_words_DB.push(KeyWord.new(word: "hejsan", point: '10'))
        key_words_DB.push(KeyWord.new(word: "trappa", point: '10'))
        key_words_DB.push(KeyWord.new(word: "skorsten", point: '10'))

        key_words_DB2.push(KeyWord.new(word: "trevlig", point: '10'))
        key_words_DB2.push(KeyWord.new(word: "min", point: '10'))
        key_words_DB2.push(KeyWord.new(word: "info", point: '10'))

        feedback_cat.key_words = key_words_DB
        feedback_cat.save
        fel_cat.key_words = key_words_DB2
        fel_cat.save
        FilterEmail.new.check_subject_and_body(temp_email1)

        expect(temp_email1.category).to eq(temp_case.category)
    end



    it "check_email_addresses: should set category to feedback_cat" do
        temp_email1.case = temp_case
        temp_email1.to = to_email_address
        temp_email1.save



        account_DB.push(temp_account)
        feedback_cat.email_accounts = account_DB
        feedback_cat.save

        FilterEmail.new.check_email_addresses(temp_email1)

        #expect(temp_email1.category).equal? feedback_cat
        expect(temp_email1.category).to eq(feedback_cat)
    end

    it "filter_mail: should set feedback_cat as its category cause it has a matching email address" do
        #IT should not chose fel_cat even though its keywords fit with contents of email
        #cause feedback_cat has a matching email address
        temp_email1.case = temp_case
        temp_email1.to = to_email_address
        temp_email1.save
        account_DB.push(temp_account)

        key_words_DB.push(KeyWord.new(word: "hejsan", point: '10'))
        key_words_DB.push(KeyWord.new(word: "trappa", point: '10'))
        key_words_DB.push(KeyWord.new(word: "skorsten", point: '10'))

        feedback_cat.email_accounts = account_DB
        feedback_cat.save
        fel_cat.key_words = key_words_DB
        fel_cat.save
        FilterEmail.new.filter_mail(temp_email1)

        expect(temp_email1.category).to eq(feedback_cat)
    end

    it "filter_mail: should set feedback_cat as its category cause it has matching words" do
        temp_email1.case = temp_case
        temp_email1.save



        account_DB.push(temp_account)
        key_words_DB.push(KeyWord.new(word: "hejsan", point: '10'))
        key_words_DB.push(KeyWord.new(word: "trappa", point: '10'))
        key_words_DB.push(KeyWord.new(word: "skorsten", point: '10'))

        feedback_cat.email_accounts = account_DB
        feedback_cat.key_words = key_words_DB
        feedback_cat.save

        key_words_DB2.push(KeyWord.new(word: "hejsan", point: '4'))
        key_words_DB2.push(KeyWord.new(word: "trappa", point: '5'))
        key_words_DB2.push(KeyWord.new(word: "skorsten", point: '1'))
        key_words_DB2.push(KeyWord.new(word: "trevlig", point: '1'))

        fel_cat.key_words = key_words_DB2
        fel_cat.save
        FilterEmail.new.filter_mail(temp_email1)

        expect(temp_email1.category).to eq(feedback_cat)
    end


    it "filter_mail: should set feedback_cat as its category cause its subject matches" do
        temp_email1.case = temp_case
        temp_email1.save

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


        fel_cat.key_words = key_words_DB2
        fel_cat.save
        FilterEmail.new.filter_mail(temp_email1)

        expect(temp_email1.category).to eq(feedback_cat)
    end


    it "check_case: filtering email with a case to check_case should return true" do
        temp_email1.case = Case.new
        filter = FilterEmail.new
        temp_email1.save
        expect(FilterEmail.new.check_case(temp_email1)).to be_truthy
    end


    it "filter_mail: should set category to feedback_cat" do
        temp_email1.case = temp_case
        temp_email1.save

        account_DB = Array.new
        temp_account = EmailAccount.new(email_address: to_email_address)
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
        fel_cat.key_words = key_words_DB2
        fel_cat.save
        FilterEmail.new.filter_mail(temp_email1)

        expect(temp_email1.category).to eq(feedback_cat)
    end

    it "filter thread: add correct categories and cases to both emails" do
        temp_email1.case = Case.new
        temp_email1.save

        temp_email2 = Email.new(subject: "Trappa", to: "info@baraspara.se",
             from: "hej@hejsan.se", body: "trappa, Min trappa ar trevlig")
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

end