# frozen_string_literal: true

class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.integer :author_id, index: true, foreign_key: true
      t.text :content, null: false

      t.timestamps
    end
  end
end
