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

=begin
    it "ThreadedFilterEmail: should set feedback_cat as its category cause it has a matching email address" do
        #IT should not chose fel_cat even though its keywords fit with contents of email
        #cause feedback_cat has a matching email address
        temp_email1.case = temp_case
        temp_email1.to = to_email_address
        temp_email1.save
        account_DB.push(temp_account)

        key_words_DB.push(KeyWord.new(word: "hejsan", point: '10'))
        key_words_DB.push(KeyWord.new(word: "brygga", point: '10'))
        key_words_DB.push(KeyWord.new(word: "trevlig", point: '10'))

        feedback_cat.email_accounts = account_DB
        feedback_cat.save
        fel_cat.key_words = key_words_DB
        fel_cat.save


        email_queue = Queue.new
        email_queue.push(temp_email1)
        ThreadedFilterEmail.new.execute_filter_threads(email_queue,1)
        #FilterEmail.new.filter_mail(temp_email1)

        expect(temp_email1.category).to eq(feedback_cat)
    end

    it "ThreadedFilterEmail: should set feedback_cat as its category cause it has a matching keyword" do
        temp_email1.case = temp_case
        #temp_email1.to = to_email_address
        temp_email1.save
        account_DB.push(temp_account)

        key_words_DB.push(KeyWord.new(word: "hejsan", point: '10'))
        key_words_DB.push(KeyWord.new(word: "brygga", point: '10'))
        key_words_DB.push(KeyWord.new(word: "trevlig", point: '10'))

        feedback_cat.email_accounts = account_DB
        feedback_cat.key_words = key_words_DB
        feedback_cat.save


        email_queue = Queue.new
        email_queue.push(temp_email1)
        ThreadedFilterEmail.new.execute_filter_threads(email_queue,1)
        #FilterEmail.new.filter_mail(temp_email1)

        expect(temp_email1.category).to eq(feedback_cat)
        expect(feedback_cat.cases.find(1)).to eq(temp_email1.case)
    end
=end
    it "ThreadedFilterEmail: All threads should work" do

        email_queue = Queue.new
        #Matching keywords with feedback
        temp_email1 = Email.new(subject: "Hejsan", to: "info@baraspara.se", from: "hej@hejsan.se",
            body: "hejsan, Min brygga ar trevlig")
        temp_email1.case = temp_case
        #temp_email1.to = to_email_address
        temp_email1.save
        email_queue.push(temp_email1)

        #Matching with both, but since subject should give x2 the points it should be trappa category
        temp_email2 = Email.new(subject: "Thread Trappa", to: "info@baraspara.se",
             from: "hej@hejsan.se", body: "trappa, Min trappa är trevlig")
        temp_email2.case = Case.new
        temp_email2.save
        email_queue.push(temp_email2)

        #Matching with both, but since subject should give x2 the points it should be trappa category
        temp_email3 = Email.new(subject: "falt. falt", to: "info@baraspara.se",
             from: "hej@hejsan.se", body: "trevlig")
        temp_email3.case = Case.new
        temp_email3.save
        email_queue.push(temp_email3)

        #should be assigned to feedback category since it has a matching email
        temp_email4 = Email.new(subject: "falt. falt", to: "feedback@baraspara.se",
             from: "hej@hejsan.se", body: "trappa")
        temp_email4.case = Case.new
        temp_email4.save
        email_queue.push(temp_email4)

        #should work with swedish words
        temp_email5 = Email.new(subject: "hallå", to: "info@baraspara.se",
             from: "hej@hejsan.se", body: "Går i ihop med flera andra gårdar")
        temp_email5.case = Case.new
        temp_email5.save
        email_queue.push(temp_email5)



        key_words_DB2.push(KeyWord.new(word: "falt", point: '4'))
        key_words_DB2.push(KeyWord.new(word: "trappa", point: '8'))
        key_words_DB2.push(KeyWord.new(word: "skorsten", point: '1'))
        key_words_DB2.push(KeyWord.new(word: "trevlig", point: '1'))
        trappa_cat = Category.new(name: "trappa kategori")

        trappa_cat.key_words = key_words_DB2
        trappa_cat.save



        key_words_DB.push(KeyWord.new(word: "hejsan", point: '10'))
        key_words_DB.push(KeyWord.new(word: "brygga", point: '10'))
        key_words_DB.push(KeyWord.new(word: "trevlig", point: '10'))
        key_words_DB.push(KeyWord.new(word: "hallå", point: '2'))


        account_DB.push(temp_account)
        feedback_cat.email_accounts = account_DB
        feedback_cat.key_words = key_words_DB
        feedback_cat.save


        
        
        
        

        ThreadedFilterEmail.new.execute_filter_threads(email_queue,1)
        #FilterEmail.new.filter_mail(temp_email1)

        expect(temp_email1.category).to eq(feedback_cat)
        expect(feedback_cat.cases.find(1)).to eq(temp_email1.case)

        expect(temp_email2.category).to eq(trappa_cat)

        expect(temp_email3.category).to eq(trappa_cat)
        expect(temp_email4.category).to eq(feedback_cat)


        expect(temp_email5.category).to eq(feedback_cat)
    end

    
=begin

    it "execute_filter_threads: should add correct categories to 10 emails in queue" do



        temp_email1.case = Case.new
        #temp_email1.subject = "thread test hejsan"
        temp_email1 = Email.new(subject: "Skorsten", to: "info@baraspara.se",
             from: "hej@hejsan.se", body: "pelle, Min feedback är trevlig")
        temp_email1.save

        temp_email2 = Email.new(subject: "Thread Trappa", to: "info@baraspara.se",
             from: "hej@hejsan.se", body: "trappa, Min trappa är trevlig")
        temp_email2.case = Case.new
        temp_email2.save

        temp_email3 = Email.new(subject: "Thread Trappa", to: to_email_address,
             from: "hej@hejsan.se", body: "trappa, Min trappa är pelle")
        temp_email3.case = Case.new
        temp_email3.save

        temp_email4 = Email.new(subject: "Thread Trappa", to: "info@baraspara.se",
             from: "hej@hejsan.se", body: "trappa, Min pelle är trevlig")
        temp_email4.case = Case.new
        temp_email4.save

        temp_email5 = Email.new(subject: "Thread Trappa", to: "info@baraspara.se",
             from: "hej@hejsan.se", body: "trappa, Min skorsten är trevlig")
        temp_email5.case = Case.new
        temp_email5.save


        email_queue = Queue.new
        email_queue.push(temp_email1)
        email_queue.push(temp_email2)
        email_queue.push(temp_email3)
        #email_queue.save

        account_DB.push(temp_account)

        key_words_DB.push(KeyWord.new(word: "hejsan", point: '10'))
        key_words_DB.push(KeyWord.new(word: "pelle", point: '10'))
        key_words_DB.push(KeyWord.new(word: "skorsten", point: '10'))

        feedback_cat.email_accounts = account_DB
        feedback_cat.key_words = key_words_DB
        #new_case2 = Case.new
        #feedback_cat.cases << new_case2
        feedback_cat.save

        key_words_DB2.push(KeyWord.new(word: "falt", point: '4'))
        key_words_DB2.push(KeyWord.new(word: "trappa", point: '8'))
        key_words_DB2.push(KeyWord.new(word: "skorsten", point: '1'))
        key_words_DB2.push(KeyWord.new(word: "trevlig", point: '1'))
        trappa_cat = Category.new(name: "trappa kategori")

        trappa_cat.key_words = key_words_DB2
        #new_case1 = Case.new
        #trappa_cat.cases << new_case1
        trappa_cat.save

        ThreadedFilterEmail.new.execute_filter_threads(email_queue,3)

        expect(temp_email1.category).to eq(feedback_cat)

        #expect(temp_email2.category).to eq(trappa_cat)
        #expect(temp_email3.category).to eq(feedback_cat)

        #expect(feedback_cat.cases.find(1)).to eq(temp_email1.case)
        #expect(trappa_cat.cases.find(2)).to eq(temp_email2.case)
    end
=end
end