# frozen_string_literal: true

require File.expand_path('../../lib/generators/voting/templates/db/migrate/create_voting_tables.rb', __dir__)

Dir[File.expand_path('db/migrate/*.rb', __dir__)].each { |file| require file }

CreateArticlesTable.new.change
CreateAuthorsTable.new.change
CreateCategoriesTable.new.change
CreateCommentsTable.new.change
CreateVotingTables.new.change
