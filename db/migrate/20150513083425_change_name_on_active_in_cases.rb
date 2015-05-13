class ChangeNameOnActiveInCases < ActiveRecord::Migration
  def change
    rename_column :cases, :active, :closed
  end
end
