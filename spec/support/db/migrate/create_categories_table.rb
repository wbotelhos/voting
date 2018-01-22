# frozen_string_literal: true

class CreateCategoriesTable < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.references :article, foreign_key: true, index: true
    end
  end
end
