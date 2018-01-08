# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Voting::Vote do
  let!(:object) { build :voting_vote }

  it { expect(object).to be_valid }

  it { is_expected.to belong_to :author }
  it { is_expected.to belong_to :resource }
  it { is_expected.to belong_to :scopeable }

  it { is_expected.to validate_presence_of :author }
  it { is_expected.to validate_presence_of :negative }
  it { is_expected.to validate_presence_of :positive }
  it { is_expected.to validate_presence_of :resource }

  it { is_expected.to validate_inclusion_of(:negative).in_array [0, 1] }
  it { is_expected.to validate_inclusion_of(:positive).in_array [0, 1] }

  it do
    expect(object).to validate_uniqueness_of(:author_id)
      .scoped_to(%i[author_type resource_id resource_type scopeable_id scopeable_type])
      .case_insensitive
  end
end
