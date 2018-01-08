# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/with_database_records'

RSpec.describe Voting::Extension, '.voted_records' do
  include_context 'with_database_records'

  it 'returns all votes that this author gave' do
    expect(author_1.voted_records).to match_array [vote_1, vote_4, vote_7]
  end
end
