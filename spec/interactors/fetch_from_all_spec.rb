require 'rails_helper'

describe FetchFromAll do

	fetcher = FetchFromAll.new

  it "only_unseen should be true" do
    expect(fetcher.instance_variable_get(:@only_unseen)).to be true
  end
end