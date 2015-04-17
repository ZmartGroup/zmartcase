class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name
  has_many :cases

  def name
    first_name + " " + last_name
  end

end
