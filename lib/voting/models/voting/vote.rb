# frozen_string_literal: true

module Voting
  class Vote < ActiveRecord::Base
    self.table_name = 'voting_votes'

    after_save :update_voting

    belongs_to :author,    polymorphic: true
    belongs_to :resource,  polymorphic: true
    belongs_to :scopeable, polymorphic: true

    validates :author, :negative, :positive, :resource, presence: true
    validates :negative, :positive, inclusion: { in: [0, 1] }

    validates :author_id, uniqueness: {
      case_sensitive: false,
      scope:          %i[author_type resource_id resource_type scopeable_id scopeable_type]
    }

    def status
      return 'positive' if positive == 1

      negative == 1 ? 'negative' : 'none'
    end

    def self.create(author:, resource:, scopeable: nil, value:)
      value     = value.to_i
      record    = find_or_initialize_by(author: author, resource: resource, scopeable: scopeable)
      attribute = value.positive? ? :positive : :negative
      canceled  = record.persisted? && value.abs == record[attribute]

      record.negative   = 0
      record.positive   = 0
      record[attribute] = value.abs unless canceled

      record.save!

      record
    end

    def self.vote_for(author:, resource:, scopeable: nil)
      find_by author: author, resource: resource, scopeable: scopeable
    end

    private

    def update_voting
      ::Voting::Voting.update_voting resource, scopeable
    end
  end
end
