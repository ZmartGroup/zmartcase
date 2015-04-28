class User < ActiveRecord::Base
  authenticates_with_sorcery!
  # attr_accessible :title, :body
  has_many :cases

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  def name
    first_name + " " + last_name
  end

end
