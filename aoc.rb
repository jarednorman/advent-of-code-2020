#!/usr/bin/env ruby

$LOAD_PATH << File.dirname(__FILE__)

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require 'fileutils'
require 'erb'

require 'zeitwerk'

module AoC
  class << self
    def run(year, day)
      setup_zeitwerk

      Runner.new(year, day).call
    end

    private

    def setup_zeitwerk
      loader = Zeitwerk::Loader.new
      loader.push_dir("/home/jardo/Codes/advent_of_code")
      loader.inflector.inflect("aoc" => "AoC")
      loader.setup
    end
  end

  class Runner
    def initialize(year, day)
      @day = day
      @year = year
    end

    def call
      unless File.directory?(day_directory_path)
        FileUtils.mkdir_p File.dirname(day_directory_path) 

        File.write(
          year_path,
          year_renderer.result(binding)
        ) unless File.exist?(year_path)

        File.write(
          day_path,
          day_renderer.result(binding)
        ) unless File.exist?(day_path)
      end

      puts "Solution:"
      puts AoC.const_get(day_const_string).new.solution
    end

    private

    attr_reader :day, :year

    def day_renderer
      ERB.new(File.read("brand_new_day.erb"))
    end

    def year_renderer
      ERB.new(File.read("month.erb"))
    end

    def year_path
      "aoc/year#{year}.rb"
    end

    def day_path
      "#{day_directory_path}.rb"
    end

    def day_directory_path
      "aoc/year#{year}/day#{day_string}"
    end

    def day_string
      "%d" % [day]
    end

    def day_const_string
      "#{year_const_string}::Day#{day_string}"
    end

    def year_const_string
      "Year#{year}"
    end
  end
end

AoC.run(*ARGV.map(&:to_i))
