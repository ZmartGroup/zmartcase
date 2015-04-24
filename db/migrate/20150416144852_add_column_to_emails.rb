class AddColumnToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :date, :datetime
    add_column :emails, :to, :string
    add_column :emails, :from, :string
  end
end
