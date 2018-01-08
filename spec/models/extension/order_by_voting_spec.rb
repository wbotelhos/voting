# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/with_database_records'

RSpec.describe Voting::Extension, ':order_by_voting' do
  include_context 'with_database_records'

  context 'with default filters' do
    it 'sorts by :estimate :desc' do
      expect(Comment.order_by_voting).to eq [
        comment_1,
        comment_2,
        comment_3
      ]
    end
  end

  context 'when filtering by :estimate' do
    context 'with asc' do
      it 'works' do
        expect(Comment.order_by_voting(:estimate, :asc)).to eq [
          comment_3,
          comment_2,
          comment_1
        ]
      end

      context 'with scope' do
        it 'works' do
          expect(Comment.order_by_voting(:estimate, :asc, scope: category)).to eq [
            comment_1
          ]
        end
      end
    end

    context 'with desc' do
      it 'works' do
        expect(Comment.order_by_voting(:estimate, :desc)).to eq [
          comment_1,
          comment_2,
          comment_3
        ]
      end

      context 'with scope' do
        it 'works' do
          expect(Comment.order_by_voting(:estimate, :desc, scope: category)).to eq [
            comment_1
          ]
        end
      end
    end
  end

  context 'when filtering by :negative' do
    context 'with asc' do
      it 'works' do
        expect(Comment.order_by_voting(:negative, :asc)).to eq [
          comment_3,
          comment_1,
          comment_2
        ]
      end

      context 'with scope' do
        it 'works' do
          expect(Comment.order_by_voting(:negative, :asc, scope: category)).to eq [
            comment_1
          ]
        end
      end
    end

    context 'with desc' do
      it 'works' do
        expect(Comment.order_by_voting(:negative, :desc)).to eq [
          comment_2,
          comment_1,
          comment_3
        ]
      end

      context 'with scope' do
        it 'works' do
          expect(Comment.order_by_voting(:negative, :desc, scope: category)).to eq [
            comment_1
          ]
        end
      end
    end
  end
end
