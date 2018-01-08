# frozen_string_literal: true

module Voting
end

require 'voting/models/voting/extension'
require 'voting/models/voting/vote'
require 'voting/models/voting/voting'

ActiveRecord::Base.include Voting::Extension
