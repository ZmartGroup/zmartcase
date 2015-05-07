class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string :word
      t.integer :amount

      t.timestamps
    end
  end
end
