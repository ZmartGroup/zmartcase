class AddCategoryIdToEmailAccount < ActiveRecord::Migration
  def change
  	add_column :email_accounts, :category_id, :integer
  end
end
