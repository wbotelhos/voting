# frozen_string_literal: true

class Author < ::ActiveRecord::Base
  voting as: :author
end
