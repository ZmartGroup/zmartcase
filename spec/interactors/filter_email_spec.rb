require 'rails_helper'


describe FilterEmail do 
	 #before(:each) do
    	#@widget = Widget.create
  	#end

	it "filtering email with a case to check_case should return true" do



		tempCase = Case.new
		tempEmail = Email.new(subject: "Hejs", to: "info@baraspara.se", from: "hej@hejsan.se", body: "JA JA JAJ A")
		tempEmail.case = tempCase
		filter = FilterEmail.new
		tempEmail.save
		expect(FilterEmail.new.check_case(tempEmail)).to be_truthy

	end

	it "create_new_case should create new case(duh!) and add it to email" do

		tempEmail = Email.new(subject: "Hejs", to: "info@baraspara.se", from: "hej@hejsan.se", body: "JA JA JAJ A")
		FilterEmail.new.create_new_case(tempEmail) 
		expect(tempEmail.case).should be_truthy

	end

	it "checkKeyWords should return 10 with a keyWord = 10" do

		#tempEmail = Email.new(subject: "nej", to: "info@baraspara.se", from: "hej@hejsan.se", body: "hejsan JA JAJ A")
		word = "hejsan"
		#tempCat = Category.new()
		tempKeyWord = KeyWord.new(word: "hejsan", point: "10")
		
		#tempCat.key_words << tempKeyWord
		key_wordsDB = Array.new

		key_wordsDB.push(tempKeyWord)

		expect(FilterEmail.new.checkKeyWords(word,key_wordsDB,false)).to be 10

	end

	it "checkKeyWords should return 20 with a keyWord = 10 with subject = true" do
		word = "hejsan"
		tempKeyWord = KeyWord.new(word: "hejsan", point: "10")
		key_wordsDB = Array.new
		key_wordsDB.push(tempKeyWord)
		expect(FilterEmail.new.checkKeyWords(word,key_wordsDB,true)).to be 20

	end

	
	#it "checkWords should return 20 with a 2 matching words worth 10" do

		#tempEmail = Email.new(subject: "nej", to: "info@baraspara.se", from: "hej@hejsan.se", body: "hejsan JA JAJ A")
		#word1 = "hejsan" , word2 = "svejsan"
		#wordsDB = Array.new
		#wordsDB.push("hejsan"); wordsDB.push("rasp"); wordsDB.push("pelle"); wordsDB.push("hejsan");



		#tempCat = Category.new()
		#tempKeyWord = KeyWord.new(word: "hejsan", point: "10")
		
		#tempCat.key_words << tempKeyW worth 10y_wordsDB = Array.new

		#key_wordsDB.push(tempKeyWord)

		#expect(FilterEmail.new.checkWords(,false)).to be 20

	end


	
end