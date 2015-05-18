require 'rails_helper'

describe MailCompressor do
	let (:some_text){"hej"}

	it "should create new file" do
    expect(MailCompressor.compress_mail(some_text)).to be_a(StringFile)
	end
end