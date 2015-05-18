require 'rails_helper'

describe FetchFromAll do

	let (:fetcher_true) {FetchFromAll.new}
  let (:fetcher_false) {FetchFromAll.new(false)}

  it "only_unseen should be true" do
    expect(fetcher_true.only_unseen).to be true
  end

  it "only_unseen should be false" do
    expect(fetcher_false.only_unseen).to be false
  end
end