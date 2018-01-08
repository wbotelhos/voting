# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/with_database_records'

RSpec.describe Voting::Extension, ':voted' do
  include_context 'with_database_records'

  context 'with no scope' do
    it 'returns votes made by this author' do
      expect(author_1.voted).to match_array [vote_1, vote_4]
    end
  end

  context 'with scope' do
    it 'returns scoped votes made by this author' do
      expect(author_1.voted(scope: category)).to eq [vote_7]
    end
  end

  context 'when destroy author' do
    it 'destroys votes of that author' do
      expect(Voting::Vote.where(author: author_1).count).to eq 3

      author_1.destroy!

      expect(Voting::Vote.where(author: author_1).count).to eq 0
    end
  end

  context 'when destroy resource voted by author' do
    it 'destroys votes of that resource' do
      expect(Voting::Vote.where(resource: comment_1).count).to eq 5

      comment_1.destroy!

      expect(Voting::Vote.where(resource: comment_1).count).to eq 0
    end
  end
end
