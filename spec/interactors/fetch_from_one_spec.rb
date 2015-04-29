require 'rails_helper'
require 'net/imap'
require 'mail'

describe FetchFromOne do

	fetcher = FetchFromOne.new(EmailAccount.new(imap: "imap.gmail.com", port: "993", enable_ssl: true, user_name: "barasparaprojtest@gmail.com", password: "Kth2015!"), false)
  badFetcher = FetchFromOne.new(EmailAccount.new(imap: "imap.gmail.com", port: "993", enable_ssl: true, user_name: "barasasdasadfest@gmail.com", password: "Kth2015!"))

  it "should be an IMAP" do
    expect(fetcher.create_imap).to be_an Net::IMAP
  end

  it "should log in via imap" do
    expect(fetcher.imap_login.raw_data).to include("(Success)")
  end

  it "should select inbox via imap" do
    expect(fetcher.imap_select_inbox.raw_data).to include("(Success)")
  end

  it "should log out" do
    expect(fetcher.imap_logout).to be_nil
  end

  it "should not log in via imap" do
    badFetcher.create_imap
    expect{badFetcher.imap_login}.to raise_error
  end

end