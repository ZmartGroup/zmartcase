class Category < ActiveRecord::Base
  attr_accessible :name

  scope :uncategorized, -> {where(name: 'Uncategorized')}

  has_many :cases
  has_many :emails
  has_many :key_words
  has_many :email_accounts
  belongs_to :filter

end
