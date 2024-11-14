# frozen_string_literal: true

require "thor"
require "frontman/version"

module Frontman
  class CLI < Thor
    desc "version", "Print the Frontman version"
    def version
      puts "Frontman #{Frontman::VERSION}"
    end
  end
end
