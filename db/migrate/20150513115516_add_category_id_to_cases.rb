class AddCategoryIdToCases < ActiveRecord::Migration
  def change
  	add_column :cases, :category_id, :integer
  end
end
