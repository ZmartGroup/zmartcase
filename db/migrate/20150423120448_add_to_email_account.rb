class AddToEmailAccount < ActiveRecord::Migration
  def change
  	add_column :email_accounts, :imap, :string
  	add_column :email_accounts, :port, :string
  	add_column :email_accounts, :user_name, :string
  	add_column :email_accounts, :password, :string
  	add_column :email_accounts, :enable_ssl, :boolean
  	
  end
end
