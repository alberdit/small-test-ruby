require 'equals/version'

module Shortener
  class Error < StandardError; end

  def self.deep_equal?(hash1, hash2)
    hash1 == hash2
  end
end
