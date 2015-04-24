class CreateEmailAccounts < ActiveRecord::Migration
  def change
    create_table :email_accounts do |t|

      t.timestamps
    end
  end
end
