require 'rails_helper'

describe EmailAccount do
	ea = EmailAccount.new(imap:"imap.gmail.com", port: "993", enable_ssl: true, user_name: "barasparaprojtest@gmail.com", password: "Kth2015!")


	it "imap should work" do
  		expect(ea.imap).to eq("imap.gmail.com")
  	end
end