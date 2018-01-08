# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/with_database_records'

RSpec.describe Voting::Extension, '.voting' do
  include_context 'with_database_records'

  it 'returns all voting of this resource' do
    expect(comment_1.voting_records).to match_array Voting::Voting.where(resource: comment_1)
  end
end
