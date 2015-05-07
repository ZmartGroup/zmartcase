require 'rails_helper'
require 'rspec/autorun'

describe Term do

	term = Term.new
	term.word = "Feedback"
	term.amount = 3

	it "is the term Feedback" do
		expect(term.word).to eq("Feedback")
	end

	it "does not allow null word" do
		term1 = Term.create(amount: 1)
		expect(term1.errors[:word]).to include("can't be blank")
	end

	it "does not allow null amount" do
		term1 = Term.create(word: "Info")
		expect(term1.errors[:amount]).to include("can't be blank")
	end

	#it "does not allow amount less than 1" do
	#	term1 = Term.create(word: "Nysälj", amount: 0)
	#	expect(term1.errors[:amount]).to include("can't have 0 as amount")
	#end

end
