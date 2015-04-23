require "rails_helper"

	describe ZmartMailer do
		before{
	  		EmailAccount.create(imap:"imap.gmail.com", port: "993", enable_ssl: true, user_name: "barasparaprojtest@gmail.com", password: "Kth2015!")
			EmailAccount.create(imap:"imap.gmail.com", port: "993", enable_ssl: true, user_name: "barasparaprojtest@gmail.com", password: "Kth2015!")
	  	}
	 

	  
	  	it "returns mails from several gmail" do

	    	@emails = ZmartMailer.fetch_all_from_all
			expect(@emails.first).to be_a Email
  		end
  	end
