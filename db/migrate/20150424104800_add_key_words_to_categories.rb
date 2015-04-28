class AddKeyWordsToCategories < ActiveRecord::Migration
  def change

    add_column :categories, :key_words, :KeyWord

  end
end
