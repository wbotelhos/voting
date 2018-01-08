# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Voting::Extension, '.up' do
  let!(:author)  { create :author }
  let!(:comment) { create :comment }

  context 'with no scopeable' do
    it 'delegates to create method' do
      expect(Voting::Vote).to receive(:create).with author: author, resource: comment, scopeable: nil, value: 1

      author.up comment
    end
  end

  context 'with scopeable' do
    let!(:category) { build :category }

    it 'delegates to create method' do
      expect(Voting::Vote).to receive(:create).with author: author, resource: comment, scopeable: category, value: 1

      author.up comment, scope: category
    end
  end
end
