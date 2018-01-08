# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/with_database_records'

RSpec.describe Voting::Extension, ':votes' do
  include_context 'with_database_records'

  context 'with no scope' do
    it 'returns votes that this resource received' do
      expect(comment_1.votes).to match_array [vote_1, vote_2, vote_3]
    end
  end

  context 'with scope' do
    it 'returns scoped votes that this resource received' do
      expect(comment_1.votes(scope: category)).to match_array [vote_7, vote_8]
    end
  end

  context 'when destroy author' do
    it 'destroys votes of that author' do
      expect(Voting::Vote.where(author: author_1).count).to eq 3

      author_1.destroy!

      expect(Voting::Vote.where(author: author_1).count).to eq 0
    end
  end

  context 'when destroy resource' do
    it 'destroys votes of that resource' do
      expect(Voting::Vote.where(resource: comment_1).count).to eq 5

      comment_1.destroy!

      expect(Voting::Vote.where(resource: comment_1).count).to eq 0
    end
  end
end
