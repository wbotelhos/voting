# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Voting::Extension, ':vote' do
  let!(:author)  { create :author }
  let!(:comment) { create :comment }

  context 'with no scopeable' do
    it 'delegates to vote object' do
      expect(Voting::Vote).to receive(:create).with author: author, resource: comment, scopeable: nil, value: 1

      author.vote comment, 1
    end
  end

  context 'with scopeable' do
    let!(:category) { build :category }

    it 'delegates to vote object' do
      expect(Voting::Vote).to receive(:create).with author: author, resource: comment, scopeable: category, value: 1

      author.vote comment, 1, scope: category
    end
  end
end
