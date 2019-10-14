# frozen_string_literal: true

FactoryBot.define do
  factory :voting_voting, class: Voting::Voting do
    estimate { 100 }

    association :resource, factory: :comment, strategy: :build
  end
end
