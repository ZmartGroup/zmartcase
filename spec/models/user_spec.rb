require 'rails_helper'


describe User do
  user = User.new
  user.first_name = "Kalle"
  user.last_name = "testsson"

  it "is named Kalle" do
    expect(user.name).to eq("Kalle testsson")
  end

  it "should not be valid user" do
    expect(user).to_not be_valid
  end

  it "should now be a valid user" do
    user.email = "kalle@zc.se"
    user.password = user.password_confirmation = "123"
    expect(user).to be_valid
  end

  it "does not allow no password" do
    user1 = User.create(
      first_name: "nisse",
      last_name: "testfeldt",
      email: "nisse@test.se")
    expect(user1.errors[:password]).to include("can't be blank")
  end


  it "does not allow duplicated emails" do
    User.create(
      first_name: "arne",
      last_name: "testgren",
      password: "arne123",
      password_confirmation: "arne123",
      email: "testmail@test.se")
    user2 = User.create(
      first_name: "bengt",
      last_name: "testberg",
      password: "bengan123",
      password_confirmation: "bengan123",
      email: "testmail@test.se")
    expect(user2.errors[:email]).to include("has already been taken")
  end

end