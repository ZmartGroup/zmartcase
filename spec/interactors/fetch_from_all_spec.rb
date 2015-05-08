require 'rails_helper'

describe FetchFromAll do

	let (:fetcher_true) {FetchFromAll.new}
  let (:fetcher_false) {FetchFromAll.new(false)}

  it "only_unseen should be true" do
    expect(fetcher.instance_variable_get(:@only_unseen)).to be true
  end

  it "only_unseen should be false" do
    expect(fetcher.instance_variable_get(:@only_unseen)).to be false
  end
end