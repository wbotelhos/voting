# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Voting::Extension, ':as' do
  context 'when is nil' do
    let!(:comment) { create :comment }

    it 'creates a voting record with values as zero to warm up the cache' do
      voting = Voting::Voting.find_by(resource: comment)

      expect(voting.negative).to  eq 0
      expect(voting.positive).to  eq 0
      expect(voting.resource).to  eq comment
      expect(voting.scopeable).to eq nil
    end
  end

  context 'when is :author' do
    let!(:author) { create :author }

    it 'does not creates a voting record' do
      expect(Voting::Voting.exists?(resource: author)).to eq false
    end
  end
end
