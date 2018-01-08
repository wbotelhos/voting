# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/with_database_records'

RSpec.describe Voting::Extension, '.votes_records' do
  include_context 'with_database_records'

  it 'returns all votes that this resource received' do
    expect(comment_1.votes_records).to match_array [vote_1, vote_2, vote_3, vote_7, vote_8]
  end
end
