class Case < ActiveRecord::Base
  attr_accessible :created_at, :user_id, :priority_id, :closed, :closed_at, :user, :category

  has_many :emails
  has_many :notes
  belongs_to :user
  belongs_to :category
  belongs_to :priority

end
