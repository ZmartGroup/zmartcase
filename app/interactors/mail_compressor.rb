class MailCompressor
  def self.compress_mail(mail)
    StringFile.new(ActiveSupport::Gzip.compress(mail), 'rawMail.gzip', 'application/x-gzip')
  end
end