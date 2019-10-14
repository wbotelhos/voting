# frozen_string_literal: true

module Voting
  module Extension
    extend ActiveSupport::Concern

    included do
      def down(resource, author: self, scope: nil)
        vote resource, -1, author: author, scope: scope
      end

      def up(resource, author: self, scope: nil)
        vote resource, 1, author: author, scope: scope
      end

      def vote(resource, value, author: self, scope: nil)
        Vote.create author: author, resource: resource, scopeable: scope, value: value
      end

      def vote_for(resource, scope: nil)
        Vote.vote_for author: self, resource: resource, scopeable: scope
      end

      def voted?(resource, value = nil, scope: nil)
        query = { author: self, resource: resource, scopeable: scope }

        query[value] = 1 unless value.nil?

        Vote.exists? query
      end

      def votes(scope: nil)
        votes_records.where scopeable: scope
      end

      def voted(scope: nil)
        voted_records.where scopeable: scope
      end

      def voting(scope: nil)
        voting_records.find_by scopeable: scope
      end

      def voting_warm_up(scoping: nil)
        return Voting.find_or_create_by(resource: self) if scoping.blank?

        [scoping].flatten.compact.map do |attribute|
          next unless respond_to?(attribute)

          [public_send(attribute)].flatten.compact.map do |object|
            Voting.find_or_create_by! resource: self, scopeable: object
          end
        end.flatten.compact
      end
    end

    module ClassMethods
      def voting(as: nil, scoping: nil)
        after_create -> { voting_warm_up scoping: scoping }, unless: -> { as == :author }

        has_many :voting_records,
                 as: :resource,
                 class_name: '::Voting::Voting',
                 dependent: :destroy

        has_many :votes_records,
                 as: :resource,
                 class_name: '::Voting::Vote',
                 dependent: :destroy

        has_many :voted_records,
                 as: :author,
                 class_name: '::Voting::Vote',
                 dependent: :destroy

        scope :order_by_voting, lambda { |column = :estimate, direction = :desc, scope: nil|
          scope_values = {
            scopeable_id: scope&.id,
            scopeable_type: scope&.class&.base_class&.name
          }

          includes(:voting_records)
            .where(Voting.table_name => scope_values)
            .order("#{Voting.table_name}.#{column} #{direction}")
        }
      end
    end
  end
end
