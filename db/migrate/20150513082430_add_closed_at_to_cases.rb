class AddClosedAtToCases < ActiveRecord::Migration
  def change
    add_column :cases, :closed_at, :datetime
  end
end
