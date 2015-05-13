require 'rails_helper'
require 'net/imap'
require 'mail'

describe FetchFromOne do
  let (:valid_email_acc) {EmailAccount.new(imap: "imap.gmail.com", port: "993", enable_ssl: true, user_name: "barasparaprojtest@gmail.com", password: "Kth2015!")}
	let (:fetcher) {FetchFromOne.new(valid_email_acc, false)}

  let (:invalid_email_acc) {EmailAccount.new(imap: "imap.gmail.com", port: "993", enable_ssl: true, user_name: "barasasdasadfest@gmail.com", password: "Kth2015!")}
  let (:bad_fetcher) {FetchFromOne.new(invalid_email_acc, false)}

  let (:imap) {double(Net::IMAP)}

  it "should create imap" do
    expect(Net::IMAP).to receive(:new){imap}
    expect(imap).to receive(:login){}
    expect(fetcher.imap).to be imap
  end

  it "should select inbox" do
    expect(Net::IMAP).to receive(:new){imap}
    expect(imap).to receive(:login){}
    expect(imap).to receive(:select).with('INBOX')
    fetcher.imap_select_inbox
  end

  it "should check the number of emails " do
    expect(Net::IMAP).to receive(:new){imap}
    expect(imap).to receive(:login){}
    expect(imap).to receive(:status).with('INBOX', any_args){Hash["MESSAGES", 0]}
    expect(fetcher.check_number_of_emails).to eq(0)
  end

  it "should read mails" do
    expect(Net::IMAP).to receive(:new){imap}
    expect(imap).to receive(:login){}
    expect(imap).to receive(:search).with(any_args){[1]}
    expect(imap).to receive(:fetch).with(any_args){[double(:attr => "")]}
    expect(Mail).to receive(:new){double(:date => "", :from => [1,2], :subject => "", :text_part => double(:body => ""))}
    expect(Email).to receive(:create)
    expect(imap).to receive(:store).with(any_args){}
    expect(fetcher).to receive(:get_case_id){2}

    fetcher.imap_readmail
  end

  it "should get the case id from the subject" do
    mail = double(Mail)
    expect(mail).to receive(:subject).twice{"hej [CaseID:<0>]"}
    expect(fetcher.get_case_id(mail)).to eq("0")
  end

  it "should get the case id from the body" do
    mail = double(Mail)
    expect(mail).to receive(:subject).once{"hej"}
    expect(mail).to receive(:text_part).twice{double(:body => "hej [CaseID:<0>]")}
    expect(fetcher.get_case_id(mail)).to eq("0")
  end

  it "should create a new case" do
    mail = double(Mail)
    expect(mail).to receive(:subject).once{"hej"}
    expect(mail).to receive(:text_part).once{double(:body => "hej")}
    expect(Case).to receive(:create){double(:id => "0")}
    expect(fetcher.get_case_id(mail)).to eq("0")
  end

  it "should log out of imap" do
    expect(Net::IMAP).to receive(:new){imap}
    expect(imap).to receive(:login){}
    expect(imap).to receive(:logout){}
    expect(imap).to receive(:disconnect){}
    fetcher.imap
    fetcher.imap_logout
  end

  it "should have right imap address" do
    expect(fetcher.email_account.imap).to eq(valid_email_acc.imap)
  end

  it "should have right port" do
    expect(fetcher.email_account.port).to eq(valid_email_acc.port)
  end

  it "should have right ssl setting" do
    expect(fetcher.email_account.enable_ssl).to be valid_email_acc.enable_ssl
  end

  it "should search for all" do
    expect(fetcher.imap_search_for).to eq("ALL")
  end

  it "should check status of emails" do
    expect(fetcher.imap_status_of).to eq("MESSAGES")
  end
end