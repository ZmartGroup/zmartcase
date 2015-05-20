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
end