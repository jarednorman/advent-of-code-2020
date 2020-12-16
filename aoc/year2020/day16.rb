module AoC::Year2020::Day16
  module Parser
    class << self
      def parse(input)
        rules, your, nearby = *input.split("\n\n")

        {
          your: parse_your(your),
          nearby: parse_nearby(nearby),
          rules: parse_rules(rules)
        }
      end

      private

      def parse_rules(rules)
        rules.split("\n").each_with_object({}) do |rule, h|
          name, ranges = rule.split(": ")
          h[name] = ranges.split(" or ").map do |range|
            Range.new(*range.split("-").map(&:to_i))
          end
        end
      end

      def parse_your(your)
        parse_ticket your.split("\n")[1]
      end

      def parse_nearby(nearby)
        nearby.split("\n")[1..-1].map do |ticket|
          parse_ticket(ticket)
        end
      end

      def parse_ticket ticket
        ticket.split(",").map(&:to_i)
      end
    end
  end

  class ParserTest < Minitest::Test
    def test_sample_input
      input = <<~INPUT
        class: 1-3 or 5-7
        row: 6-11 or 33-44
        seat: 13-40 or 45-50

        your ticket:
        7,1,14

        nearby tickets:
        7,3,47
        40,4,50
        55,2,20
        38,6,12
      INPUT

      assert_equal({
        your: [7, 1, 14],
        nearby: [
          [7, 3, 47],
          [40, 4, 50],
          [55, 2, 20],
          [38, 6, 12]
        ],
        rules: {
          "class" => [1..3, 5..7],
          "row" => [6..11, 33..44],
          "seat" => [13..40, 45..50]
        }
      }, Parser.parse(input))
    end
  end

  class Part1
    def initialize(input = real_input)
      @input = Parser.parse(input)
    end

    def solution
      valid_nums = Set.new input[:rules].values.flatten.flat_map(&:to_a)
      input[:nearby].flatten.sum { |n| valid_nums.include?(n) ? 0: n }
    end

    private

    attr_reader :input

    def real_input
      @input ||= File.read("aoc/year2020/day16.txt")
    end
  end

  class Part1Test < Minitest::Test
    def test_sample_input
      assert_equal 71, Part1.new(<<~INPUT).solution
        class: 1-3 or 5-7
        row: 6-11 or 33-44
        seat: 13-40 or 45-50

        your ticket:
        7,1,14

        nearby tickets:
        7,3,47
        40,4,50
        55,2,20
        38,6,12
      INPUT
    end
  end

  class Part2 < Part1
    def solution
      0
    end
  end

  class Part2Test < Minitest::Test
    def test_sample_input
      assert_equal 0, Part2.new(<<~INPUT).solution
      INPUT
    end
  end
end

