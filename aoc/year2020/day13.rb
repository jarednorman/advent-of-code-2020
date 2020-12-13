module AoC::Year2020::Day13
  class Part1
    def initialize(input = real_input)
      @input = input

      @timestamp = input.split("\n").first.to_i
      @buses = input.split("\n").last.split(",").map(&:to_i).reject(&:zero?)
    end

    def solution
      h = buses.map do |bus|
        x = timestamp / bus

        if x * bus == timestamp
          [bus, 0]
        else
          [bus, (x + 1) * bus - timestamp]
        end
      end

      h.min_by(&:last).inject(&:*)
    end

    private

    attr_reader :timestamp, :buses

    def real_input
      @input ||= File.read("aoc/year2020/day13.txt")
    end
  end

  class Part1Test < Minitest::Test
    def test_sample_input
      assert_equal 295, Part1.new(<<~INPUT).solution
        939
        7,13,x,x,59,x,31,19
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

