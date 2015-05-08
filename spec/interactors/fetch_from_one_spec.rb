require 'rails_helper'
require 'net/imap'
require 'mail'

describe FetchFromOne do
  let (:valid_email_acc) {EmailAccount.new(imap: "imap.gmail.com", port: "993", enable_ssl: true, user_name: "barasparaprojtest@gmail.com", password: "Kth2015!")}
	let (:fetcher) {FetchFromOne.new(valid_email_acc, false)}

  let (:invalid_email_acc) {EmailAccount.new(imap: "imap.gmail.com", port: "993", enable_ssl: true, user_name: "barasasdasadfest@gmail.com", password: "Kth2015!")}
  let (:bad_fetcher) {FetchFromOne.new(invalid_email_acc, false)}

  it "should have imap address imap.gmail.com" do
    expect(fetcher.email_account.imap).to eq("imap.gmail.com")
  end

  it "should have imap port 993" do
    expect(fetcher.email_account.port).to eq("993")
  end

  it "should have imap ssl enabled" do
    expect(fetcher.email_account.enable_ssl).to be true
  end

  it "should search for all" do
    expect(fetcher.imap_search_for).to eq("ALL")
  end

  it "should count all emails" do
    expect(fetcher.imap_status_of).to eq("MESSAGES")
  end



=begin
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
=end

end