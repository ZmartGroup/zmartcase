require 'rails_helper'
require 'net/imap'
require 'mail'

describe FetchFromOne do
  let (:valid_email_acc) {EmailAccount.new(imap: "imap.gmail.com", port: "993", enable_ssl: true, user_name: "barasparaprojtest@gmail.com", password: "Kth2015!")}
	let (:fetcher) {FetchFromOne.new(valid_email_acc, false)}

  let (:invalid_email_acc) {EmailAccount.new(imap: "imap.gmail.com", port: "993", enable_ssl: true, user_name: "barasasdasadfest@gmail.com", password: "Kth2015!")}
  let (:bad_fetcher) {FetchFromOne.new(invalid_email_acc, false)}

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
    bad_fetcher.create_imap
    expect{bad_fetcher.imap_login}.to raise_error
  end
end