require 'rails_helper'

describe Email do
	it "should return a mail object" do
    Email.create(case_id: "0",
                 raw: MailCompressor.compress_mail(Mail.new(to: "a@b.c", subject: "hej", body: "hej")),
                 to: "a@b.c",
                 subject: "hej",
                 body: "hej")
    expect(Email.last.get_decompressed_mail).to be_a(Mail::Message)
	end

  it "should decompress right" do
    Email.create(case_id: "0",
                 raw: MailCompressor.compress_mail(Mail.new(to: "a@b.c", subject: "hej", body: "hej")),
                 to: "a@b.c",
                 subject: "hej",
                 body: "hej")
    expect(Email.last.get_decompressed_mail.subject).to eq("hej")
  end
end