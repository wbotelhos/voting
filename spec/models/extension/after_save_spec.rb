# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Voting::Extension, 'after_save' do
  context 'when record is author' do
    let!(:record) { build :author }

    it 'does warm up the cache' do
      expect(record).not_to receive(:voting_warm_up)

      record.save
    end
  end

  context 'when record is not author' do
    context 'when record has scoping' do
      let!(:record) { build :article }

      it 'warms up the cache' do
        expect(record).to receive(:voting_warm_up).with(scoping: :categories)

        record.save
      end
    end

    context 'when record has no scoping' do
      let!(:record) { build :comment }

      it 'warms up the cache' do
        expect(record).to receive(:voting_warm_up).with(scoping: nil)

        record.save
      end
    end
  end
end
