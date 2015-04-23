require 'rails_helper'


describe User do

  it "is named Kalle" do
    user = User.new
    user.first_name = "Kalle"
    user.last_name = "testsson"
    expect(user.name).to eq("Kalle testsson")
  end

end