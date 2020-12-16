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
      fields = (0..input[:your].length - 1).map { nil }

      until fields.all?
        fields.each_with_index.each do |field, index|
          next if field

          nums = values_at_index index
          hits = input[:rules].select { |name, ranges|
            nums.all? { |n|
              ranges.any? { |r|
                r.include? n
              }
            }
          }.map(&:first)

          if hits.length == 1
            hit = hits.first
            input[:rules].delete(hit)
            fields[index] = hit
          end
        end
      end

      # This I think works.
      fields.each_with_index.map do |field, index|
        if /\Adeparture /.match? field
          input[:your][index]
        else
          1
        end
      end.inject(&:*)
    end

    private

    def values_at_index n
      valid_nearby.map { |ticket| ticket[n] }
    end

    def valid_nearby
      @valid_nearby ||= input[:nearby].select { |ticket| ticket.all? { |n| valid_nums.include?(n) } }
    end

    def valid_nums
      @valid_nums ||= Set.new input[:rules].values.flatten.flat_map(&:to_a)
    end
  end

  class Part2Test < Minitest::Test
    def test_whatever
      puts Part2.new(<<~INPUT).solution.inspect
        class: 0-1 or 4-19
        row: 0-5 or 8-19
        seat: 0-13 or 16-19

        your ticket:
        11,12,13

        nearby tickets:
        3,9,18
        15,1,5
        5,14,9
      INPUT
    end
  end
end

