# frozen_string_literal: true

module Voting
  class Voting < ActiveRecord::Base
    self.table_name = 'voting_votings'

    belongs_to :resource,  polymorphic: true
    belongs_to :scopeable, polymorphic: true

    validates :estimate, :negative, :positive, :resource, presence: true
    validates :estimate, numericality: true
    validates :negative, :positive, numericality: { greater_than_or_equal_to: 0, only_integer: true }

    validates :resource_id, uniqueness: {
      case_sensitive: false,
      scope: %i[resource_type scopeable_id scopeable_type]
    }

    class << self
      def values_data(resource, scopeable)
        sql = %(
          SELECT
            COALESCE(SUM(negative), 0) voting_negative,
            COALESCE(SUM(positive), 0) voting_positive
          FROM #{vote_table_name}
          WHERE resource_type = ? and resource_id = ? and #{scope_query(scopeable)}
        ).squish

        values =  [sql, resource.class.name, resource.id]
        values += [scopeable.class.name, scopeable.id] unless scopeable.nil?

        execute_sql values
      end

      def update_voting(resource, scopeable)
        record = find_or_initialize_by(resource: resource, scopeable: scopeable)
        values = values_data(resource, scopeable)

        record.estimate = estimate(values)
        record.negative = values.voting_negative
        record.positive = values.voting_positive

        record.save!
      end

      private

      def estimate(values)
        sum = values.voting_negative + values.voting_positive

        return 0 if sum.zero?

        square = Math.sqrt((values.voting_negative * values.voting_positive) / sum + 0.9604)

        ((values.voting_positive + 1.9208) / sum - 1.96 * square / sum) / (1 + 3.8416 / sum)
      end

      def execute_sql(sql)
        Vote.find_by_sql(sql).first
      end

      def vote_table_name
        @vote_table_name ||= Vote.table_name
      end

      def scope_query(scopeable)
        return 'scopeable_type is NULL and scopeable_id is NULL' if scopeable.nil?

        'scopeable_type = ? and scopeable_id = ?'
      end
    end
  end
end
