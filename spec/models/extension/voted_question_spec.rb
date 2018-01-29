# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Voting::Extension, ':voted?' do
  let!(:author)  { create :author }
  let!(:comment) { create :comment }

  context 'with no scopeable' do
    context 'with no specific value' do
      context 'when has no vote for the given resource' do
        specify { expect(author.voted?(comment)).to eq false }
      end

      context 'when has vote for the given resource' do
        before { author.up comment }

        specify { expect(author.voted?(comment)).to eq true }
      end
    end

    context 'with specific value' do
      context 'with negative' do
        context 'when has no vote for the given resource' do
          specify { expect(author.voted?(comment, :negative)).to eq false }
        end

        context 'when has vote for the given resource' do
          before { author.down comment }

          specify { expect(author.voted?(comment, :negative)).to eq true }
        end

        context 'when has vote for the given resource but positive' do
          before { author.up comment }

          specify { expect(author.voted?(comment, :negative)).to eq false }
        end
      end

      context 'with positive' do
        context 'when has no vote for the given resource' do
          specify { expect(author.voted?(comment, :positive)).to eq false }
        end

        context 'when has vote for the given resource' do
          before { author.up comment }

          specify { expect(author.voted?(comment, :positive)).to eq true }
        end

        context 'when has vote for the given resource but negative' do
          before { author.down comment }

          specify { expect(author.voted?(comment, :positive)).to eq false }
        end
      end
    end
  end

  context 'with scopeable' do
    let!(:category) { build :category }

    context 'with no specific value' do
      context 'when has no vote for the given resource' do
        specify { expect(author.voted?(comment, scope: category)).to eq false }
      end

      context 'when has vote for the given resource' do
        before { author.up comment, scope: category }

        specify { expect(author.voted?(comment, scope: category)).to eq true }
      end
    end

    context 'with specific value' do
      context 'with negative' do
        context 'when has no vote for the given resource' do
          specify { expect(author.voted?(comment, :negative, scope: category)).to eq false }
        end

        context 'when has vote for the given resource' do
          before { author.down comment, scope: category }

          specify { expect(author.voted?(comment, :negative, scope: category)).to eq true }
        end

        context 'when has vote for the given resource but positive' do
          before { author.up comment, scope: category }

          specify { expect(author.voted?(comment, :negative, scope: category)).to eq false }
        end
      end

      context 'with positive' do
        context 'when has no vote for the given resource' do
          specify { expect(author.voted?(comment, :positive, scope: category)).to eq false }
        end

        context 'when has vote for the given resource' do
          before { author.up comment, scope: category }

          specify { expect(author.voted?(comment, :positive, scope: category)).to eq true }
        end

        context 'when has vote for the given resource negative' do
          before { author.down comment, scope: category }

          specify { expect(author.voted?(comment, :positive, scope: category)).to eq false }
        end
      end
    end
  end
end
