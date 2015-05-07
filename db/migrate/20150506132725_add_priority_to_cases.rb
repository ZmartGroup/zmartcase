class AddPriorityToCases < ActiveRecord::Migration
  def change
    add_column :cases, :priority_id, :integer
  end
end
