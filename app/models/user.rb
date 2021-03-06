class User < ActiveRecord::Base
  rolify
  authenticates_with_sorcery!
  # attr_accessible :title, :body
  has_many :cases
  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  def name
    first_name.capitalize + " " + last_name.capitalize
  end

end
