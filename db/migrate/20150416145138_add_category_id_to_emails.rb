class AddCategoryIdToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :category_id, :integer
  end
end
