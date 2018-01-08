# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Voting::Vote, ':create' do
  let!(:author) { create :author }

  context 'with no scopeable' do
    let!(:resource) { create :comment }

    context 'when vote does not exist yet' do
      it 'creates a vote entry' do
        described_class.create author: author, resource: resource, value: 1

        vote = described_class.last

        expect(vote.author).to   eq author
        expect(vote.negative).to eq 0
        expect(vote.positive).to eq 1
        expect(vote.resource).to eq resource
      end

      it 'creates a voting entry' do
        described_class.create author: author, resource: resource, value: 1

        voting = Voting::Voting.last

        expect(voting.estimate).to eq 0.2065432914738929
        expect(voting.negative).to eq 0
        expect(voting.positive).to eq 1
        expect(voting.resource).to eq resource
      end
    end

    context 'when vote already exists by other author' do
      let!(:author_other) { create :author }

      before { described_class.create author: author_other, resource: resource, value: -1 }

      it 'creates one more vote entry' do
        described_class.create author: author, resource: resource, value: 1

        votes = described_class.all.order('created_at asc')

        expect(votes.size).to eq 2

        vote = votes[0]

        expect(vote.author).to   eq author_other
        expect(vote.negative).to eq 1
        expect(vote.positive).to eq 0
        expect(vote.resource).to eq resource

        vote = votes[1]

        expect(vote.author).to   eq author
        expect(vote.negative).to eq 0
        expect(vote.positive).to eq 1
        expect(vote.resource).to eq resource
      end

      it 'updates the unique voting entry' do
        described_class.create author: author, resource: resource, value: 1

        voting = Voting::Voting.all

        expect(voting.size).to eq 1

        expect(voting[0].estimate).to eq 0.1711859764448097
        expect(voting[0].negative).to eq 1
        expect(voting[0].positive).to eq 1
        expect(voting[0].resource).to eq resource
      end
    end

    context 'when vote already exists by the same author' do
      before { described_class.create author: author, resource: resource, value: -1 }

      context 'when author vote with a different rate' do
        it 'changes the actual vote' do
          described_class.create author: author, resource: resource, value: 1

          votes = described_class.all.order('created_at asc')

          expect(votes.size).to eq 1

          expect(votes[0].author).to   eq author
          expect(votes[0].negative).to eq 0
          expect(votes[0].positive).to eq 1
          expect(votes[0].resource).to eq resource
        end

        it 'updates the unique voting entry' do
          described_class.create author: author, resource: resource, value: 1

          voting = Voting::Voting.all

          expect(voting.size).to eq 1

          expect(voting[0].estimate).to eq 0.2065432914738929
          expect(voting[0].negative).to eq 0
          expect(voting[0].positive).to eq 1
          expect(voting[0].resource).to eq resource
        end
      end

      context 'when author vote with the same rate' do
        it 'makes the vote be zero' do
          described_class.create author: author, resource: resource, value: -1

          votes = described_class.all.order('created_at asc')

          expect(votes.size).to eq 1

          expect(votes[0].author).to   eq author
          expect(votes[0].negative).to eq 0
          expect(votes[0].positive).to eq 0
          expect(votes[0].resource).to eq resource
        end

        it 'updates the unique voting entry' do
          described_class.create author: author, resource: resource, value: -1

          voting = Voting::Voting.all

          expect(voting.size).to eq 1

          expect(voting[0].estimate).to eq 0
          expect(voting[0].negative).to eq 0
          expect(voting[0].positive).to eq 0
          expect(voting[0].resource).to eq resource
        end
      end
    end
  end

  context 'with scopeable' do
    let!(:scopeable) { create :category }
    let!(:resource)  { create :article }

    context 'when vote does not exist yet' do
      it 'creates a vote entry' do
        described_class.create author: author, resource: resource, scopeable: scopeable, value: 1

        vote = described_class.last

        expect(vote.author).to    eq author
        expect(vote.negative).to  eq 0
        expect(vote.positive).to  eq 1
        expect(vote.resource).to  eq resource
        expect(vote.scopeable).to eq scopeable
      end

      it 'creates a voting entry' do
        described_class.create author: author, resource: resource, scopeable: scopeable, value: 1

        voting = Voting::Voting.last

        expect(voting.estimate).to  eq 0.2065432914738929
        expect(voting.negative).to  eq 0
        expect(voting.positive).to  eq 1
        expect(voting.resource).to  eq resource
        expect(voting.scopeable).to eq scopeable
      end
    end

    context 'when vote already exists by other author' do
      let!(:author_other) { create :author }

      before { described_class.create author: author_other, resource: resource, scopeable: scopeable, value: -1 }

      it 'creates one more vote entry' do
        described_class.create author: author, resource: resource, scopeable: scopeable, value: 1

        votes = described_class.all.order('created_at asc')

        expect(votes.size).to eq 2

        vote = votes[0]

        expect(vote.author).to    eq author_other
        expect(vote.negative).to  eq 1
        expect(vote.positive).to  eq 0
        expect(vote.resource).to  eq resource
        expect(vote.scopeable).to eq scopeable

        vote = votes[1]

        expect(vote.author).to    eq author
        expect(vote.negative).to  eq 0
        expect(vote.positive).to  eq 1
        expect(vote.resource).to  eq resource
        expect(vote.scopeable).to eq scopeable
      end

      it 'updates the unique voting entry' do
        described_class.create author: author, resource: resource, scopeable: scopeable, value: 1

        voting = Voting::Voting.all

        expect(voting.size).to eq 1

        expect(voting[0].estimate).to  eq 0.1711859764448097
        expect(voting[0].negative).to  eq 1
        expect(voting[0].positive).to  eq 1
        expect(voting[0].resource).to  eq resource
        expect(voting[0].scopeable).to eq scopeable
      end
    end

    context 'when vote already exists by the same author' do
      before { described_class.create author: author, resource: resource, scopeable: scopeable, value: -1 }

      context 'when author vote with a different rate' do
        it 'changes the actual vote' do
          described_class.create author: author, resource: resource, scopeable: scopeable, value: 1

          votes = described_class.all.order('created_at asc')

          expect(votes.size).to eq 1

          expect(votes[0].author).to    eq author
          expect(votes[0].negative).to  eq 0
          expect(votes[0].positive).to  eq 1
          expect(votes[0].resource).to  eq resource
          expect(votes[0].scopeable).to eq scopeable
        end

        it 'updates the unique voting entry' do
          described_class.create author: author, resource: resource, scopeable: scopeable, value: 1

          voting = Voting::Voting.all

          expect(voting.size).to eq 1

          expect(voting[0].estimate).to  eq 0.2065432914738929
          expect(voting[0].negative).to  eq 0
          expect(voting[0].positive).to  eq 1
          expect(voting[0].resource).to  eq resource
          expect(voting[0].scopeable).to eq scopeable
        end
      end

      context 'when author vote with the same rate' do
        it 'makes the vote be zero' do
          described_class.create author: author, resource: resource, scopeable: scopeable, value: -1

          votes = described_class.all.order('created_at asc')

          expect(votes.size).to eq 1

          expect(votes[0].author).to   eq author
          expect(votes[0].negative).to eq 0
          expect(votes[0].positive).to eq 0
          expect(votes[0].resource).to eq resource
        end

        it 'updates the unique voting entry' do
          described_class.create author: author, resource: resource, scopeable: scopeable, value: -1

          voting = Voting::Voting.all

          expect(voting.size).to eq 1

          expect(voting[0].estimate).to eq 0
          expect(voting[0].negative).to eq 0
          expect(voting[0].positive).to eq 0
          expect(voting[0].resource).to eq resource
        end
      end
    end
  end
end
