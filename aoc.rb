#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

module AoC
  class << self
    def command(argv)
      puts argv.inspect
    end
  end
end

AoC.command(ARGV)
