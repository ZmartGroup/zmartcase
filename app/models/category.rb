class Category < ActiveRecord::Base
  attr_accessible :name

  has_many :cases
  has_many :emails
  has_many :key_words
  has_many :email_accounts
  belongs_to :filter

end
