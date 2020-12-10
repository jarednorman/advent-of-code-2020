module AoC::Year2020::Day10
  class Part1
    def initialize(input = real_input)
      @input = input.split("\n").map(&:to_i)
    end

    def solution
      ones = 0
      threes = 1
      ([0] + input).sort.each_cons(2) do |a,b|
        ones += 1 if b - a == 1
        threes += 1 if b - a == 3
      end
      ones * threes
    end

    private

    attr_reader :input

    def real_input
      @input ||= File.read("aoc/year2020/day10.txt")
    end
  end

  class Part1Test < Minitest::Test
    def test_sample_input_one
      assert_equal 35, Part1.new(<<~INPUT).solution
        16
        10
        15
        5
        1
        11
        7
        19
        6
        12
        4
      INPUT
    end

    def test_sample_input_two
      assert_equal 220, Part1.new(<<~INPUT).solution
        28
        33
        18
        42
        31
        14
        46
        20
        48
        47
        24
        23
        49
        45
        19
        38
        39
        11
        1
        32
        25
        35
        8
        17
        7
        9
        4
        2
        34
        10
        3
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

