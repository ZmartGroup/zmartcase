class AddHashTagAndActiveToCase < ActiveRecord::Migration
  def change

  	add_column :cases, :hashtag, :string
  	add_column :cases, :active, :boolean
  end
end

