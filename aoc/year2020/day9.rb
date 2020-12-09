module AoC::Year2020::Day9
  class Part1
    def initialize(input = real_input)
      @input = input.split("\n").map(&:to_i)
    end

    def solution
      input.each_cons(26) do |x|
        num = x.last
        cands = x[0..24]

        return num unless cands.combination(2).any?{|z|z.sum == num}
      end
    end

    private

    attr_reader :input

    def real_input
      @input ||= File.read("aoc/year2020/day9.txt")
    end
  end

  class Part1Test < Minitest::Test
    def test_sample_input
      assert_equal 0, Part1.new(<<~INPUT).solution
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

