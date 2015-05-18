require 'rails_helper'

describe WordcountController do

	it "start_counting: Should read trough an email and count all the terms" do

		tmpMail = Email.create(subject: "Feedback", body: "duktiga")

		WordcountController.new.start_counting

		expect(tmpMail.body).equal? Term.last
	end
end
