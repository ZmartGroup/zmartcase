class AddColumnToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :type_id, :integer
  end
end
