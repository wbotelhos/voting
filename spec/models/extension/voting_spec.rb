# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/with_database_records'

RSpec.describe Voting::Extension, '.voting' do
  include_context 'with_database_records'

  context 'with no scope' do
    it 'returns voting record' do
      expect(comment_1.voting).to eq Voting::Voting.find_by(resource: comment_1, scopeable: nil)
    end
  end

  context 'with scope' do
    it 'returns scoped voting record' do
      expect(comment_1.voting(scope: category)).to eq Voting::Voting.find_by(resource: comment_1, scopeable: category)
    end
  end

  context 'when destroy author' do
    it 'does not destroy resource voting' do
      expect(Voting::Voting.where(resource: comment_1).count).to eq 2

      author_1.destroy!

      expect(Voting::Voting.where(resource: comment_1).count).to eq 2
    end
  end

  context 'when destroy resource' do
    it 'destroys resource voting too' do
      expect(Voting::Voting.where(resource: comment_1).count).to eq 2

      comment_1.destroy!

      expect(Voting::Voting.where(resource: comment_1).count).to eq 0
    end
  end
end
