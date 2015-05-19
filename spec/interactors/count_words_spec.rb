# encoding: UTF-8
require 'rails_helper'

describe CountWords do

	term = "hej"

	it "Should check the term hej and return true if it's present" do

		test = CountWords.new.checkTerm(term)
		expect(test) == true

	end

	it "Should create the term Feedback" do

		CountWords.new.createTerm("Feedback")
		expect(Term.last.word).equal? "Feedback"

	end

	it "Should add +1 to the amount for the word hej" do

		CountWords.new.createTerm("hej")
		CountWords.new.addAmount(term)
		expect(Term.first.amount) == 2

	end

	it "Should split an emails subject and body into an array" do

		testMail = Email.create(subject: "Feedback till kundservice", body: "Ni är duktiga")

		testForSubject = CountWords.new.splitSubject(testMail)
		testForBody = CountWords.new.splitBody(testMail)

		expect(testForSubject).eql? ["feedback", "till", "kundservice"]
		expect(testForBody).eql? ["ni", "är", "duktiga"]

	end


	
end