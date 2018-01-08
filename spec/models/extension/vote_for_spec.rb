# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Voting::Extension, ':vote_for' do
  let!(:author)  { create :author }
  let!(:comment) { create :comment }

  context 'with no scopeable' do
    it 'delegates to vote object' do
      expect(Voting::Vote).to receive(:vote_for).with author: author, resource: comment, scopeable: nil

      author.vote_for comment
    end
  end

  context 'with scopeable' do
    let!(:category) { build :category }

    it 'delegates to vote object' do
      expect(Voting::Vote).to receive(:vote_for).with author: author, resource: comment, scopeable: category

      author.vote_for comment, scope: category
    end
  end
end
