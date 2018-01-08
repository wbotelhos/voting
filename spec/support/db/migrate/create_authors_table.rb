# frozen_string_literal: true

class CreateAuthorsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :authors
  end
end
