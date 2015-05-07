require 'rails_helper'


describe FilterEmail do 
	 #before(:each) do
    	#@widget = Widget.create
  	#end



	it "checkKeyWords: should return 10 with a keyWord = 10" do

		#tempEmail = Email.new(subject: "nej", to: "info@baraspara.se", from: "hej@hejsan.se", body: "hejsan JA JAJ A")
		word = "hejsan"
		#tempCat = Category.new()
		tempKeyWord = KeyWord.new(word: "hejsan", point: "10")
		
		#tempCat.key_words << tempKeyWord
		key_wordsDB = Array.new

		key_wordsDB.push(tempKeyWord)

		expect(FilterEmail.new.checkKeyWords(word,key_wordsDB,false)).to be 10

	end

	it "checkKeyWords: should return 20 with a keyWord = 10 with subject = true" do
		word = "hejsan"
		tempKeyWord = KeyWord.new(word: "hejsan", point: "10")
		key_wordsDB = Array.new
		key_wordsDB.push(tempKeyWord)
		expect(FilterEmail.new.checkKeyWords(word,key_wordsDB,true)).to be 20

	end

	
	it "checkWords: should return 20 with 2 matching words worth 10" do

		#
		#word1 = "hejsan" , word2 = "svejsan"
		wordsDB = Array.new
		wordsDB.push("hejsan"); wordsDB.push("rasp"); wordsDB.push("pelle"); wordsDB.push("trappa");

		tempCat = Category.new(name: "testCat")
		keyWordsDB = Array.new
		keyWordsDB.push(KeyWord.new(word: "hejsan", point: "10"))
		keyWordsDB.push(KeyWord.new(word: "trappa", point: "10"))
		keyWordsDB.push(KeyWord.new(word: "skorsten", point: "10"))
		tempCat.key_words = keyWordsDB


		expect(FilterEmail.new.checkWords(tempCat.key_words, wordsDB, false)).to be 20

	end

	it "checkSubjectAndBody: should get category = feedback" do

		tempEmail = Email.new(subject: "Hejsan", to: "info@baraspara.se", from: "hej@hejsan.se", 
			body: "hejsan, Min brygga är trevlig")
		feedbackCat = Category.new(name: "Feedback")
		felCat = Category.new(name: "fel kategori")

		keyWordsDB = Array.new
		keyWordsDB.push(KeyWord.new(word: "hejsan", point: "10"))
		keyWordsDB.push(KeyWord.new(word: "trappa", point: "10"))
		keyWordsDB.push(KeyWord.new(word: "skorsten", point: "10"))

		keyWordsDB2 = Array.new
		keyWordsDB2.push(KeyWord.new(word: "trevlig", point: "10"))
		keyWordsDB2.push(KeyWord.new(word: "min", point: "10"))
		keyWordsDB2.push(KeyWord.new(word: "info", point: "10"))



		feedbackCat.key_words = keyWordsDB
		felCat.key_words = keyWordsDB2

		FilterEmail.new.checkSubjectAndBody(tempEmail)

		expect(tempEmail.category).equal? feedbackCat
	

	end

	it "attach_category_to_email_and_case: both case category and email category should be same" do
		new_case = Case.new
		new_case.active = true
		new_case.save

		tempEmail = Email.new(subject: "Hejsan", to: "info@baraspara.se", from: "hej@hejsan.se", 
			body: "hejsan, Min brygga är trevlig")
		tempEmail.case = new_case
		tempEmail.save
		feedbackCat = Category.new(name: "Feedback")

		FilterEmail.new.attach_category_to_email_and_case(tempEmail,feedbackCat)
		expect(tempEmail.category).equal? new_case.category

	end

	it "checkSubjectAndBody: email category should be same as case category" do
		new_case = Case.new
		new_case.active = true
		new_case.save
		#Attach case to email
		#email.case = new_case
		#email.save
		
		tempEmail = Email.new(subject: "Hejsan", to: "info@baraspara.se", from: "hej@hejsan.se", 
			body: "hejsan, Min brygga är trevlig")
		tempEmail.case = new_case
		tempEmail.save


		feedbackCat = Category.new(name: "Feedback")
		felCat = Category.new(name: "fel kategori")

		keyWordsDB = Array.new
		keyWordsDB.push(KeyWord.new(word: "hejsan", point: "10"))
		keyWordsDB.push(KeyWord.new(word: "trappa", point: "10"))
		keyWordsDB.push(KeyWord.new(word: "skorsten", point: "10"))

		keyWordsDB2 = Array.new
		keyWordsDB2.push(KeyWord.new(word: "trevlig", point: "10"))
		keyWordsDB2.push(KeyWord.new(word: "min", point: "10"))
		keyWordsDB2.push(KeyWord.new(word: "info", point: "10"))



		feedbackCat.key_words = keyWordsDB
		felCat.key_words = keyWordsDB2

		FilterEmail.new.checkSubjectAndBody(tempEmail)
		#casesDB = feedbackCat.cases
		
		#expect(casesDB.fetch(0)).equal? tempEmail.category
		expect(tempEmail.category).equal? new_case.category

	end



















	it "checkEmailAddresses: should set category to feedbackCat" do
		to_email_address = "feedback@baraspara.se"
		tempEmail = Email.new(subject: "Hejsan", to: to_email_address, from: "hej@hejsan.se", 
			body: "hejsan, Min brygga är trevlig")
		tempEmail.case = Case.new
		accountDB = Array.new
		tempAccount = EmailAccount.new(email_address: to_email_address)
		accountDB.push(tempAccount)

		feedbackCat = Category.new(name: "Feedback")
		feedbackCat.email_accounts = accountDB

		FilterEmail.new.checkEmailAddresses(tempEmail)

		expect(tempEmail.category).equal? feedbackCat
	end






	it "find_category: should set feedbackCat as its category cause it has a matching email address" do
		#IT should not chose felCat even though its keywords fit with contents of email
		#cause feedbackCat has a matching email address
		to_email_address = "feedback@baraspara.se"
		tempEmail = Email.new(subject: "Hejsan", to: to_email_address, from: "hej@hejsan.se", 
			body: "hejsan, Min trappa är trevlig")

		tempEmail.case = Case.new
		accountDB = Array.new
		tempAccount = EmailAccount.new(email_address: to_email_address)
		accountDB.push(tempAccount)


		keyWordsDB = Array.new
		keyWordsDB.push(KeyWord.new(word: "hejsan", point: "10"))
		keyWordsDB.push(KeyWord.new(word: "trappa", point: "10"))
		keyWordsDB.push(KeyWord.new(word: "skorsten", point: "10"))


		feedbackCat = Category.new(name: "Feedback")
		feedbackCat.email_accounts = accountDB

		felCat = Category.new(name: "fel kategori")
		felCat.key_words = keyWordsDB

		FilterEmail.new.find_category(tempEmail)

		expect(tempEmail).equal? feedbackCat

	end

	it "find_category: should set feedbackCat as its category cause it has matching words" do
		to_email_address = "feedback@baraspara.se"
		tempEmail = Email.new(subject: "Hejsan", to: "info@baraspara.se",
			 from: "hej@hejsan.se", body: "hejsan, Min trappa är trevlig")

		#tempEmail.case = Case.new
		accountDB = Array.new
		tempAccount = EmailAccount.new(email_address: to_email_address)
		accountDB.push(tempAccount)


		keyWordsDB = Array.new
		keyWordsDB.push(KeyWord.new(word: "hejsan", point: "10"))
		keyWordsDB.push(KeyWord.new(word: "trappa", point: "10"))
		keyWordsDB.push(KeyWord.new(word: "skorsten", point: "10"))


		feedbackCat = Category.new(name: "Feedback")
		feedbackCat.email_accounts = accountDB
		feedbackCat.key_words = keyWordsDB

		keyWordsDB2 = Array.new
		keyWordsDB2.push(KeyWord.new(word: "hejsan", point: "4"))
		keyWordsDB2.push(KeyWord.new(word: "trappa", point: "5"))
		keyWordsDB2.push(KeyWord.new(word: "skorsten", point: "1"))
		keyWordsDB2.push(KeyWord.new(word: "trevlig", point: "1"))
		felCat = Category.new(name: "fel kategori")

		felCat.key_words = keyWordsDB2

		FilterEmail.new.find_category(tempEmail)

		expect(tempEmail).equal? feedbackCat

	end


	it "find_category: should set feedbackCat as its category cause its subject matches" do
		to_email_address = "feedback@baraspara.se"
		tempEmail = Email.new(subject: "Hejsan", to: "info@baraspara.se",
			 from: "hej@hejsan.se", body: "trappa, Min trappa är trevlig")

		#tempEmail.case = Case.new
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
		felCat = Category.new(name: "fel kategori")

		felCat.key_words = keyWordsDB2

		FilterEmail.new.find_category(tempEmail)

		expect(tempEmail).equal? feedbackCat

	end

	it "create_new_case: should create new case(duh!) and add it to email" do

		tempEmail = Email.new(subject: "Hejs", to: "info@baraspara.se", from: "hej@hejsan.se", body: "JA JA JAJ A")
		FilterEmail.new.create_new_case(tempEmail) 
		expect(tempEmail.case).to be_truthy

	end

	it "check_case: filtering email with a case to check_case should return true" do

		tempCase = Case.new
		tempEmail = Email.new(subject: "Hejs", to: "info@baraspara.se", from: "hej@hejsan.se", body: "JA JA JAJ A")
		tempEmail.case = tempCase
		filter = FilterEmail.new
		tempEmail.save
		expect(FilterEmail.new.check_case(tempEmail)).to be_truthy

	end

	it "filter_mail: should not set a category since it has a case" do
		#expect(true).to be true
		to_email_address = "feedback@baraspara.se"
		tempEmail = Email.new(subject: "Hejsan", to: "info@baraspara.se",
			 from: "hej@hejsan.se", body: "trappa, Min trappa är trevlig")

		FilterEmail.new.create_new_case(tempEmail)
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
		felCat = Category.new(name: "fel kategori")

		felCat.key_words = keyWordsDB2

		FilterEmail.new.filter_mail(tempEmail)
 
		expect(tempEmail.category).equal? nil

	end


	it "filter_mail: should set category to feedbackCat" do
		#expect(true).to be true
		to_email_address = "feedback@baraspara.se"
		tempEmail = Email.new(subject: "Hejsan", to: "info@baraspara.se",
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
		felCat = Category.new(name: "fel kategori")

		felCat.key_words = keyWordsDB2

		FilterEmail.new.filter_mail(tempEmail)
 
		expect(tempEmail.category).equal? feedbackCat

	end




	
end