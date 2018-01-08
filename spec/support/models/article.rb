# frozen_string_literal: true

class Article < ::ActiveRecord::Base
  voting scoping: :categories

  has_many :categories
end
