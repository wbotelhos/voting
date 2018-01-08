# frozen_string_literal: true

FactoryBot.define do
  factory :voting_vote, class: Voting::Vote do
    author   { create :author }
    resource { create :comment }
  end
end
