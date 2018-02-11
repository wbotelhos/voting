# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Voting::Extension, ':vote' do
  let!(:author)   { create :author }
  let!(:resource) { create :comment }

  context 'with no scopeable' do
    it 'delegates to vote object' do
      expect(Voting::Vote).to receive(:create).with author: author, resource: resource, scopeable: nil, value: 1

      author.vote resource, 1
    end
  end

  context 'with scopeable' do
    let!(:category) { build :category }

    it 'delegates to vote object' do
      expect(Voting::Vote).to receive(:create).with author: author, resource: resource, scopeable: category, value: 1

      author.vote resource, 1, scope: category
    end
  end

  it 'creates the vote with string value' do
    author.vote resource, '1'

    vote = Voting::Vote.last

    expect(vote.author).to   eq author
    expect(vote.negative).to eq 0
    expect(vote.positive).to eq 1
    expect(vote.resource).to eq resource

    author.vote resource, '-1'

    vote.reload

    expect(vote.author).to   eq author
    expect(vote.negative).to eq 1
    expect(vote.positive).to eq 0
    expect(vote.resource).to eq resource
  end
end
