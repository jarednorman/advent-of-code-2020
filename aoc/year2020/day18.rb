module AoC::Year2020::Day18
  module Parser
    class << self
      def parse(input)
        input = input.chars.reject { |x| x == " " }
        parse_expression(input)
      end

      def parse_expression(input)
        result = get_term(input)

        until input.empty?
          op = get_operator(input)
          return result if op == :")"

          b = get_term(input)

          result = [result, op, b]
        end

        result
      end

      def get_term(input)
        n = input.shift

        if /\d/.match(n)
          n.to_i
        else
          parse_expression(input)
        end
      end

      def get_operator(input)
        input.shift.to_sym
      end
    end
  end

  class ParserTest < Minitest::Test
    def test_examples
      assert_equal(
        [[[[[1, :+, 2], :*, 3], :+, 4], :*, 5], :+, 6 ],
        Parser.parse("1 + 2 * 3 + 4 * 5 + 6")
      )

      assert_equal(
        [[1, :+, [2, :*, 3]], :+, [4, :*, [5, :+, 6]]],
        Parser.parse("1 + (2 * 3) + (4 * (5 + 6))")
      )
    end
  end

  class Part1
    def initialize(input = real_input)
      @input = input.split("\n").map { |problem| Parser.parse(problem) }
    end

    def solution
      input.sum { |problem|
        solve problem
      }
    end

    private

    attr_reader :input

    def solve(problem)
      return problem if problem.is_a? Integer

      a = problem[0]
      op = problem[1]
      b = problem[2]

      case op
      when :+ then solve(a) + solve(b)
      when :* then solve(a) * solve(b)
      end
    end

    def real_input
      @input ||= File.read("aoc/year2020/day18.txt")
    end
  end

  class Part1Test < Minitest::Test
    def test_sample_input
      assert_equal 13754, Part1.new(<<~INPUT).solution
        1 + 2 * 3 + 4 * 5 + 6
        1 + (2 * 3) + (4 * (5 + 6))
        ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2
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

