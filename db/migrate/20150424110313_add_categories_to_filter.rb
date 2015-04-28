class AddCategoriesToFilter < ActiveRecord::Migration
	def change
		add_column :Categories, :filter_id, :integer
	end
end
