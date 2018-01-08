# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/with_database_records'

RSpec.describe Voting::Voting, ':update_voting' do
  include_context 'with_database_records'

  context 'with no scopeable' do
    it 'updates the voting data of the given resource' do
      record = described_class.find_by(resource: comment_1)

      expect(record.estimate).to eq 0.2923292797006548
      expect(record.negative).to eq 1
      expect(record.positive).to eq 2
    end
  end

  context 'with scopeable' do
    it 'updates the voting data of the given resource respecting the scope' do
      record = described_class.find_by(resource: comment_1, scopeable: category)

      expect(record.estimate).to eq 0.1711859764448097
      expect(record.negative).to eq 1
      expect(record.positive).to eq 1
    end
  end
end
