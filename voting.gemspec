# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'voting/version'

Gem::Specification.new do |spec|
  spec.author      = 'Washington Botelho'
  spec.description = 'A Binomial proportion confidence interval voting system with scope and cache enabled.'
  spec.email       = 'wbotelhos@gmail.com'
  spec.files       = Dir['lib/**/*'] + %w[CHANGELOG.md LICENSE README.md]
  spec.homepage    = 'https://github.com/wbotelhos/voting'
  spec.license     = 'MIT'
  spec.name        = 'voting'
  spec.platform    = Gem::Platform::RUBY
  spec.summary     = 'A Binomial proportion confidence interval voting system with scope and cache enabled.'
  spec.test_files  = Dir['spec/**/*']
  spec.version     = Voting::VERSION

  spec.add_dependency 'activerecord'

  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'shoulda-matchers'
  spec.add_development_dependency 'sqlite3'
end
