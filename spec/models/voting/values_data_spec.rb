# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/with_database_records'

RSpec.describe Voting::Voting, ':values_data' do
  include_context 'with_database_records'

  context 'with no scopeable' do
    subject(:voting) { described_class.values_data comment_1, nil }

    it { expect(voting.as_json['voting_positive']).to eq 2 }

    it { expect(voting.as_json['voting_negative']).to eq 1 }
  end

  context 'with scopeable' do
    subject(:voting) { described_class.values_data comment_1, category }

    it { expect(voting.as_json['voting_positive']).to eq 1 }

    it { expect(voting.as_json['voting_negative']).to eq 1 }
  end
end
