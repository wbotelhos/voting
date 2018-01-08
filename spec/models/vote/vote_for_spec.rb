# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Voting::Vote, ':vote_for' do
  let!(:author)  { create :author }
  let!(:comment) { create :comment }

  context 'with no scopeable' do
    context 'when vote does not exist' do
      specify { expect(described_class.vote_for(author: author, resource: comment)).to eq nil }
    end

    context 'when vote does not exist' do
      before { create :voting_vote, author: author, resource: comment, positive: 1 }

      it 'returns the record' do
        expect(described_class.vote_for(author: author, resource: comment)).to eq described_class.last
      end
    end
  end

  context 'with scopeable' do
    let!(:category) { create :category }

    context 'when vote does not exist' do
      specify { expect(described_class.vote_for(author: author, resource: comment, scopeable: category)).to eq nil }
    end

    context 'when vote does not exist' do
      before { create :voting_vote, author: author, resource: comment, scopeable: category, positive: 1 }

      it 'returns the record' do
        query = described_class.vote_for(author: author, resource: comment, scopeable: category)

        expect(query).to eq described_class.last
      end
    end
  end
end
