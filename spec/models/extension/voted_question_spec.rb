# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Voting::Extension, ':voted?' do
  let!(:author)  { create :author }
  let!(:comment) { create :comment }

  context 'with no scopeable' do
    context 'when has no vote for the given resource' do
      before { allow(author).to receive(:vote_for).with(comment, scope: nil) { nil } }

      specify { expect(author.voted?(comment)).to eq false }
    end

    context 'when has vote for the given resource' do
      before { allow(author).to receive(:vote_for).with(comment, scope: nil) { double } }

      specify { expect(author.voted?(comment)).to eq true }
    end
  end

  context 'with scopeable' do
    let!(:category) { build :category }

    context 'when has no vote for the given resource' do
      before { allow(author).to receive(:vote_for).with(comment, scope: category) { nil } }

      specify { expect(author.voted?(comment, scope: category)).to eq false }
    end

    context 'when has vote for the given resource' do
      before { allow(author).to receive(:vote_for).with(comment, scope: category) { double } }

      specify { expect(author.voted?(comment, scope: category)).to eq true }
    end
  end
end
