require "rails_helper"


describe ZmartMailer do
	EmailAccount.create(imap:"imap.gmail.com", port: "993", enable_ssl: true, user_name: "barasparaprojtest@gmail.com", password: "Kth2015!")
	EmailAccount.create(imap:"imap.gmail.com", port: "993", enable_ssl: true, user_name: "barasparaprojtest@gmail.com", password: "Kth2015!")

  	it "returns all mails from several gmail" do
    	@emails = ZmartMailer.fetch_all_from_all
		@emails.each do |email|
			expect(email).to be_a Email
		end
	end

	it "returns new mails from several gmail" do
    	@emails = ZmartMailer.fetch_new_from_all
		@emails.each do |email|
			expect(email).to be_a Email
		end
	end
end