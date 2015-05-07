class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :subject
      t.text :body
      t.integer :case_id
      t.integer :user_id

      t.timestamps
    end
  end
end
