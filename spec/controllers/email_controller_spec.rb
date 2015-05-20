require 'rails_helper'

describe EmailsController do
	it "creates new email" do
		expect{
      post :create, email: { to: "a@b.c", case_id: "0", subject: "hej", body: "hej"}
    }.to change(Email, :count).by(1)
	end

  it "adds case_id from form to subject" do
    post :create, email: { to: "a@b.c", case_id: "0", subject: "hej", body: "hej"}
    expect(Email.last.subject).to eq("hej [CaseID:<0>]")
  end

  it "doesn't change subject when it includes CaseID" do
    post :create, email: { to: "a@b.c", case_id: "0", subject: "hej [CaseID:<1>]", body: "hej"}
    expect(Email.last.subject).to eq("hej [CaseID:<1>]")
  end

  it "creates a new case if it doesn't get one from the form" do
    post :create, email: { to: "a@b.c", subject: "hej", body: "hej"}
    expect(Email.last.case_id).to be_truthy
  end

  it "should " do
    email = double(Email)
    mail = double(Mail)
    expect(Email).to receive(:new){email}
    expect(email).to receive(:is_sent=){}
    expect(email).to receive(:case_id){0}
    expect(email).to receive(:subject){"[CaseID:"}
    expect(MailSender).to receive(:create_email){mail}
    expect(mail).to receive(:deliver)
    expect(email).to receive(:raw=){}
    expect(email).to receive(:save){}
    post :create, email: { to: "a@b.c", subject: "hej", body: "hej", attachment: 5}

    expect(File).to receive(:read).twice{}
 end



  it "should test SHOW" do
    e = Email.create( to: "a@b.c", subject: "hej", body: "hej")
    get :show, id: e.id
    expect(response).to render_template :show
  end

  it "should test INDEX" do
    get :index
    expect(response).to render_template :index
  end

  it "should test NEW" do
    get :new
    expect(response).to render_template :new
  end
end