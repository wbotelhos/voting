# frozen_string_literal: true

class CreateVotingTables < ActiveRecord::Migration[5.0]
  def change
    create_table :voting_votes do |t|
      t.integer :negative, default: 0, null: false
      t.integer :positive, default: 0, null: false

      t.references :author,    index: true, null: false, polymorphic: true
      t.references :resource,  index: true, null: false, polymorphic: true
      t.references :scopeable, index: true, null: true,  polymorphic: true

      t.timestamps null: false
    end

    add_index :voting_votes, %i[author_id author_type resource_id resource_type scopeable_id scopeable_type],
              name: :index_voting_votes_on_author_and_resource_and_scopeable,
              unique: true

    create_table :voting_votings do |t|
      t.decimal :estimate, default: 0, mull: false, precision: 25, scale: 20
      t.integer :negative, default: 0, null: false
      t.integer :positive, default: 0, null: false

      t.references :resource,  index: true, null: false, polymorphic: true
      t.references :scopeable, index: true, null: true,  polymorphic: true

      t.timestamps null: false
    end

    add_index :voting_votings, %i[resource_id resource_type scopeable_id scopeable_type],
              name: :index_voting_votings_on_resource_and_scopeable,
              unique: true
  end
end
