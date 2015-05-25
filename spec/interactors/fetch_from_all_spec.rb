require 'rails_helper'


describe FetchFromAll do

  it "only_unseen should be true" do
    expect(FetchFromAll.new.only_unseen).to be true
  end

  it "only_unseen should be false" do
    expect(FetchFromAll.new(false).only_unseen).to be false
  end

  it "should call FetchFromOne for every EmailAccount" do
    ffo = double(FetchFromOne.new(1,2))
  	expect(EmailAccount).to receive(:all){[1,2]}
    expect(FetchFromOne).to receive(:new).twice{ffo}
    expect(ffo).to receive(:perform).twice{Queue.new}
    FetchFromAll.new.perform
  end
end