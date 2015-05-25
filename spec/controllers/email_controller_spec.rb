require 'rails_helper'

describe EmailsController do
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