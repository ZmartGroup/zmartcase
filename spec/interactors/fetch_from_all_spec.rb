require 'rails_helper'


describe FetchFromAll do

  it "only_unseen should be true" do
    expect(FetchFromAll.new.only_unseen).to be true
  end

  it "only_unseen should be false" do
    expect(FetchFromAll.new(false).only_unseen).to be false
  end
end