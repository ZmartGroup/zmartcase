class AddSentToEmail < ActiveRecord::Migration
  def change
  	add_column :Emails, :is_sent, :boolean
  end
end
