# encoding: UTF-8
require 'rails_helper'

describe CountWords do

	term = "hej"

	it "Should count the words for an email" do

		test_mail = 	Email.create(subject: "Feedback till kundservice", body: "Ni är duktiga duktiga")

		CountWords.new.count(test_mail)

		expect(Term.last.word).equal? "duktiga"
		expect(Term.last.amount) == 2

	end


	it "Should check the term hej and return true if it's present" do

		test = CountWords.new.check_term(term)
		expect(test) == true

	end

	it "Should create the term Feedback" do

		CountWords.new.create_term("Feedback")
		expect(Term.last.word).equal? "Feedback"

	end

	it "Should add +1 to the amount for the word hej" do

		CountWords.new.create_term("hej")
		CountWords.new.add_amount(term)
		expect(Term.first.amount) == 2

	end

	it "Should split an emails subject and body into an array" do

		test_mail = Email.create(subject: "Feedback till kundservice", body: "Ni är duktiga")

		test_for_subject = CountWords.new.seperate_words(test_mail.subject)
		test_for_body = CountWords.new.seperate_words(test_mail.body)

		expect(test_for_subject).eql? ["feedback", "till", "kundservice"]
		expect(test_for_body).eql? ["ni", "är", "duktiga"]

	end


	
end