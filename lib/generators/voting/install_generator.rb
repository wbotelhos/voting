# frozen_string_literal: true

module Voting
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    desc 'creates Voting migration'

    def create_migration
      template 'db/migrate/create_voting_tables.rb', "db/migrate/#{timestamp}_create_voting_tables.rb"
    end

    private

    def timestamp
      Time.current.strftime '%Y%m%d%H%M%S'
    end
  end
end
