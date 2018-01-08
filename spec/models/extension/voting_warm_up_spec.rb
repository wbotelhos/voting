# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Voting::Extension, '.voting_warm_up' do
  context 'when scoping is nil' do
    context 'when update is made' do
      let!(:record) { create :comment }
      let!(:voting) { ::Voting::Voting.find_by resource: record }

      it 'creates the cache' do
        record.voting_warm_up scoping: nil

        expect(::Voting::Voting.all).to eq [voting]
      end

      it 'returns the cached object' do
        expect(record.voting_warm_up).to eq voting
      end
    end

    context 'when record does not exist' do
      let!(:record) { create :comment }

      before { ::Voting::Voting.destroy_all }

      it 'creates the cache' do
        record.voting_warm_up scoping: nil

        expect(::Voting::Voting.all.map(&:resource)).to eq [record]
      end

      it 'returns the cached object' do
        expect(record.voting_warm_up).to eq ::Voting::Voting.last
      end
    end
  end

  context 'when scoping is not nil' do
    context 'when update is made' do
      let!(:category_1) { create :category }
      let!(:category_2) { create :category }
      let!(:record)     { create :article, categories: [category_1, category_2] }

      it 'creates the cache' do
        record.voting_warm_up scoping: :categories

        votings = ::Voting::Voting.all

        expect(votings.map(&:scopeable)).to match_array [category_1, category_2]
        expect(votings.map(&:resource)).to  match_array [record, record]
      end

      it 'returns the cached objects' do
        expect(record.voting_warm_up(scoping: :categories)).to eq ::Voting::Voting.all
      end
    end

    context 'when record does not exist' do
      let!(:category_1) { create :category }
      let!(:category_2) { create :category }
      let!(:record)     { create :article, categories: [category_1, category_2] }

      before { ::Voting::Voting.destroy_all }

      it 'creates the cache' do
        record.voting_warm_up scoping: :categories

        votings = ::Voting::Voting.all

        expect(votings.map(&:scopeable)).to match_array [category_1, category_2]
        expect(votings.map(&:resource)).to  match_array [record, record]
      end

      it 'returns the cached objects' do
        expect(record.voting_warm_up(scoping: :categories)).to eq ::Voting::Voting.all
      end
    end

    context 'when a non existent scoping is given' do
      let!(:record) { create :article }

      it 'returns an empty array' do
        expect(record.voting_warm_up(scoping: :missing)).to eq []
      end
    end

    context 'when scoping is given inside array' do
      let!(:category) { create :category }
      let!(:record)   { create :article, categories: [category] }

      it 'returns the cache' do
        expect(record.voting_warm_up(scoping: [:categories])).to eq ::Voting::Voting.all
      end
    end

    context 'when scoping is given inside multiple arrays' do
      let!(:category) { create :category }
      let!(:record)   { create :article, categories: [category] }

      it 'returns the cache' do
        expect(record.voting_warm_up(scoping: [[:categories]])).to eq ::Voting::Voting.all
      end
    end

    context 'when scoping is given with nil value together' do
      let!(:category) { create :category }
      let!(:record)   { create :article, categories: [category] }

      it 'returns the cache' do
        expect(record.voting_warm_up(scoping: [[:categories, nil], nil])).to eq ::Voting::Voting.all
      end
    end
  end
end
