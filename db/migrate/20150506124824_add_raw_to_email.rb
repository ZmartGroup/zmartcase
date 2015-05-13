class AddRawToEmail < ActiveRecord::Migration
  def change
  	add_column :Emails, :raw, :string
  end
end
