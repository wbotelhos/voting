# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Voting::Vote, '.status' do
  let!(:author)   { create :author }
  let!(:resource) { create :comment }

  context 'with no scope' do
    it 'returns the status' do
      expect(author.up(resource).status).to   eq 'positive'
      expect(author.down(resource).status).to eq 'negative'
      expect(author.down(resource).status).to eq 'none'
    end
  end

  context 'with scope' do
    let!(:scope) { create :category }

    it 'returns the status' do
      expect(author.up(resource, scope: scope).status).to   eq 'positive'
      expect(author.down(resource, scope: scope).status).to eq 'negative'
      expect(author.down(resource, scope: scope).status).to eq 'none'
    end
  end

  it 'respect the scope' do
    no_scope   = author.up(resource)
    with_scope = author.down(resource, scope: create(:category))

    expect(no_scope.status).to   eq 'positive'
    expect(with_scope.status).to eq 'negative'
  end
end
