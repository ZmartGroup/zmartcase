class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :subject
      t.text :body
      t.integer :case_id

      t.timestamps
    end
  end
end
