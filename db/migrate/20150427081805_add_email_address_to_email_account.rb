class AddEmailAddressToEmailAccount < ActiveRecord::Migration
  def change
  	add_column :email_accounts, :email_address, :string
  end
end
