class CreateKeyWords < ActiveRecord::Migration
  def change
    create_table :key_words do |t|
      t.string :word
      t.integer :point
      t.integer :category_id
      t.timestamps
    end
  end
end
