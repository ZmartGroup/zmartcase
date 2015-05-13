class EmailsController < ApplicationController

  def index
  end

  def show
    #@category = Category.find(params[:category_id])
    #@emails = @category.emails
    #@email = @category.emails.find(params[:id])
    @email = Email.find(params[:id])
  end

  def edit
  end

  def index
    @emails = Email.all
  end

  def new
    @email = Email.new
  end

  def create
    @email = Email.new(params[:email])
    @email.is_sent = true;
    unless @email.subject.include?("[CaseID:")
      @email.subject += " [CaseID:<" + @email.case_id.to_s + ">]"
    end
    mail = MailSender.create_email(@email)

=begin                                    #get attachments from UI
    attachments = Array.new
    attachments.push "/home/olsom/testStuff.txt"
    attachments.push "/home/olsom/anotherTest.txt"

    attachments.each do |attachment|
      mail.add_file(attachment)
    end
=end

    mail.deliver
    @email.raw = MailCompressor.compress_mail(mail)
    @email.save
    redirect_to new_category_path
  end

  def update
  end

  def destroy
  end
end