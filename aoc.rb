#!/usr/bin/env ruby

$LOAD_PATH << File.dirname(__FILE__)

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require 'fileutils'
require 'erb'
require 'net/http'

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
      loader.push_dir(__dir__)
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
      if File.exist?(day_path)
        klass = AoC.const_get(day_const_string)

        if RSpec::Core::Runner.run([], STDERR, STDOUT) == 0
          commit "Tests pass for year #{year} day #{day}"

          puts "Solution for year #{year} day #{day}:"
          puts klass.new.solution
        end
      else
        puts "Generating year #{year} day #{day}!"

        FileUtils.mkdir_p File.dirname(day_directory_path) 

        generate_file(
          path: year_path,
          contents: year_renderer.result(binding)
        )

        generate_file(
          path: day_path,
          contents: day_renderer.result(binding)
        )

        generate_file(
          path: input_path,
          contents: input_data
        )

        commit "Generate year #{year} day #{day}"
      end
    end

    private

    attr_reader :day, :year

    def commit(message)
      system(*%W(git add .))
      system(*%W(git commit -m #{message}))
    end

    def generate_file(contents:, path:)
      File.write(path, contents) unless File.exist?(input_path)
    end

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

    def input_path
      "#{day_directory_path}.txt"
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

    def input_data
      uri = URI("https://adventofcode.com/#{year}/day/#{day}/input")
      http = Net::HTTP.new(uri.host, 443)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)
      request['Cookie'] = ENV.fetch('AOC_SESSION_COOKIE')
      response = http.request(request)
      response.body
    end
  end
end

AoC.run(*ARGV.map(&:to_i))
