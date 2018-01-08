# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Voting::Voting do
  let!(:object) { build :voting_voting }

  it { expect(object).to be_valid }

  it { is_expected.to belong_to :resource }
  it { is_expected.to belong_to :scopeable }

  it { is_expected.to validate_presence_of :estimate }
  it { is_expected.to validate_presence_of :negative }
  it { is_expected.to validate_presence_of :positive }
  it { is_expected.to validate_presence_of :resource }

  it { is_expected.to validate_numericality_of(:negative).is_greater_than_or_equal_to(0).only_integer }
  it { is_expected.to validate_numericality_of(:positive).is_greater_than_or_equal_to(0).only_integer }

  it do
    expect(object).to validate_uniqueness_of(:resource_id)
      .scoped_to(%i[resource_type scopeable_id scopeable_type])
      .case_insensitive
  end
end
