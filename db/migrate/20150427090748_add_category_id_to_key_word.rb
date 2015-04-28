class AddCategoryIdToKeyWord < ActiveRecord::Migration
  def change
  	add_column :key_words, :category_id, :integer
  end
end
